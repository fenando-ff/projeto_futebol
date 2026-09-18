from datetime import timedelta
from io import StringIO
from contextlib import redirect_stdout
from unittest.mock import patch

from django.contrib.auth.hashers import check_password, make_password
from django.core import mail
from django.db import connection
from django.test import Client, TestCase
from django.urls import reverse
from django.utils import timezone

from .models import CategoriaCliente, Clientes, RecuperacaoSenha
from .serializers import RecuperacaoSenhaSerializer


class SegurancaFluxosTests(TestCase):
    """HTTP, middleware, sessoes, templates e ORM reais em banco descartavel."""

    @classmethod
    def setUpClass(cls):
        cls.tabelas_criadas = []
        with connection.schema_editor() as editor:
            for model in (CategoriaCliente, Clientes, RecuperacaoSenha):
                if model._meta.db_table not in connection.introspection.table_names():
                    editor.create_model(model)
                    cls.tabelas_criadas.append(model)
        super().setUpClass()

    @classmethod
    def tearDownClass(cls):
        super().tearDownClass()
        with connection.schema_editor() as editor:
            for model in reversed(cls.tabelas_criadas):
                editor.delete_model(model)

    def setUp(self):
        self.nao_socio = CategoriaCliente.objects.create(
            pk=5, nome_categoria_clientes="Nao socio", descricao_categ_cli="", preco_categ=0,
        )
        self.plano = CategoriaCliente.objects.create(
            pk=2, nome_categoria_clientes="Diamante", descricao_categ_cli="Plano", preco_categ=300,
        )
        self.outro_plano = CategoriaCliente.objects.create(
            pk=3, nome_categoria_clientes="Ouro", descricao_categ_cli="Plano", preco_categ=200,
        )
        self.pessoa = Clientes.objects.create(
            email_clientes="cliente@example.com", senha_clientes=make_password("Anterior1"),
            nome_clientes="Cliente", sobrenome_clientes="Teste", cpf_clientes="12345678901",
            sexo_clientes="N", telefone_clientes="11999999999", status_clientes=1,
            categoria_cliente_id_categoria_cliente=self.nao_socio,
        )

    def iniciar(self):
        response = self.client.post(reverse("recuperar_senha"), {"email": self.pessoa.email_clientes})
        self.assertRedirects(response, reverse("recuperar_senha2"), fetch_redirect_response=False)
        return RecuperacaoSenha.objects.latest("id")

    def validar(self):
        registro = self.iniciar()
        response = self.client.post(reverse("recuperar_senha2"), {"codigo": registro.codigo})
        self.assertRedirects(response, reverse("recuperar_senha3"), fetch_redirect_response=False)
        return registro

    def login(self, client=None):
        client = client or self.client
        session = client.session
        session["cliente_id"] = self.pessoa.pk
        session.save()

    def selecionar(self):
        self.login()
        response = self.client.post(reverse("selecionar_plano_socio", args=[self.plano.pk]))
        self.assertRedirects(response, reverse("confirmar_socio", args=[self.plano.pk]),
                             fetch_redirect_response=False)

    def assertSenhaOriginal(self):
        self.pessoa.refresh_from_db()
        self.assertTrue(check_password("Anterior1", self.pessoa.senha_clientes))

    def test_etapas_diretas_get_e_post_bloqueadas(self):
        for rota in ("recuperar_senha2", "recuperar_senha3"):
            for method in (self.client.get, self.client.post):
                with self.subTest(rota=rota, method=method):
                    response = method(reverse(rota), {"senha": "NovaSenha1", "confirmar_senha": "NovaSenha1"})
                    self.assertRedirects(response, reverse("recuperar_senha"), fetch_redirect_response=False)
        self.assertSenhaOriginal()

    def test_etapa_1_nao_autoriza_etapa_3(self):
        self.iniciar()
        response = self.client.get(reverse("recuperar_senha3"))
        self.assertRedirects(response, reverse("recuperar_senha"), fetch_redirect_response=False)

    def test_fluxo_completo_sem_expor_codigo_e_sem_reutilizacao(self):
        registro = self.iniciar()
        self.assertIn(registro.codigo, mail.outbox[0].body)
        response = self.client.get(reverse("recuperar_senha2"))
        self.assertEqual(response.status_code, 200)
        self.assertNotContains(response, registro.codigo)
        self.assertIn("no-store", response.headers["Cache-Control"])
        self.assertNotIn(registro.codigo, str(dict(self.client.session)))
        self.client.post(reverse("recuperar_senha2"), {"codigo": registro.codigo})
        self.assertEqual(self.client.get(reverse("recuperar_senha3")).status_code, 200)
        sessao_validada = dict(self.client.session)
        response = self.client.post(reverse("recuperar_senha3"),
                                    {"senha": "NovaSenha1", "confirmar_senha": "NovaSenha1"})
        self.assertRedirects(response, reverse("login"), fetch_redirect_response=False)
        self.pessoa.refresh_from_db()
        self.assertTrue(check_password("NovaSenha1", self.pessoa.senha_clientes))
        self.assertFalse(RecuperacaoSenha.objects.exists())
        self.assertNotIn("recuperacao_id", self.client.session)
        session = self.client.session
        session.update(sessao_validada)
        session.save()
        response = self.client.post(reverse("recuperar_senha3"),
                                    {"senha": "Reutilizada1", "confirmar_senha": "Reutilizada1"})
        self.assertRedirects(response, reverse("recuperar_senha"), fetch_redirect_response=False)
        self.pessoa.refresh_from_db()
        self.assertTrue(check_password("NovaSenha1", self.pessoa.senha_clientes))

    def test_codigo_errado_nao_valida_e_limite_invalida_registro(self):
        registro = self.iniciar()
        for _ in range(4):
            response = self.client.post(reverse("recuperar_senha2"), {"codigo": "errado"})
            self.assertContains(response, "Dados de recuperacao invalidos ou expirados.")
            self.assertNotIn("recuperacao_validada_id", self.client.session)
        response = self.client.post(reverse("recuperar_senha2"), {"codigo": "errado"})
        self.assertRedirects(response, reverse("recuperar_senha"), fetch_redirect_response=False)
        self.assertFalse(RecuperacaoSenha.objects.filter(pk=registro.pk).exists())

    def test_expiracao_revalidada_em_ambas_etapas_get_e_post(self):
        for rota in ("recuperar_senha2", "recuperar_senha3"):
            for method in (self.client.get, self.client.post):
                with self.subTest(rota=rota, method=method):
                    registro = self.validar()
                    RecuperacaoSenha.objects.filter(pk=registro.pk).update(criado_em=timezone.now()-timedelta(hours=3))
                    response = method(reverse(rota), {"codigo": registro.codigo,
                                      "senha": "NovaSenha1", "confirmar_senha": "NovaSenha1"})
                    self.assertRedirects(response, reverse("recuperar_senha"), fetch_redirect_response=False)
        self.assertSenhaOriginal()

    def test_recomecar_limpa_validacao_anterior(self):
        self.validar()
        self.iniciar()
        self.assertNotIn("recuperacao_validada_id", self.client.session)
        self.assertEqual(self.client.get(reverse("recuperar_senha3")).status_code, 302)

    def test_validar_uma_conta_nao_autoriza_trocar_senha_de_outra(self):
        self.validar()
        outra_pessoa = Clientes.objects.get(pk=self.pessoa.pk)
        outra_pessoa.pk = None
        outra_pessoa.email_clientes = "outra@example.com"
        outra_pessoa.cpf_clientes = "98765432100"
        outra_pessoa.save()
        self.client.post(reverse("recuperar_senha"), {"email": outra_pessoa.email_clientes})
        response = self.client.post(reverse("recuperar_senha3"),
                                    {"senha": "Invasao123", "confirmar_senha": "Invasao123"})
        self.assertRedirects(response, reverse("recuperar_senha"), fetch_redirect_response=False)
        outra_pessoa.refresh_from_db()
        self.assertTrue(check_password("Anterior1", outra_pessoa.senha_clientes))
        self.assertSenhaOriginal()

    def test_voltar_etapa_1_limpa_estado(self):
        self.validar()
        self.client.get(reverse("recuperar_senha"))
        self.assertNotIn("recuperacao_id", self.client.session)
        self.assertNotIn("recuperacao_validada_id", self.client.session)

    def test_email_inexistente_limpa_validacao_anterior(self):
        self.validar()
        response = self.client.post(reverse("recuperar_senha"), {"email": "inexistente@example.com"})
        self.assertEqual(response.status_code, 200)
        self.assertNotIn("recuperacao_id", self.client.session)
        self.assertNotIn("recuperacao_validada_id", self.client.session)

    def test_falha_email_nao_libera_etapa_2(self):
        for resultado in (RuntimeError("falha"), 0):
            kwargs = {"side_effect": resultado} if isinstance(resultado, Exception) else {"return_value": resultado}
            with patch("app_futebol.views.views.send_mail", **kwargs):
                response = self.client.post(reverse("recuperar_senha"), {"email": self.pessoa.email_clientes})
            self.assertEqual(response.status_code, 200)
            self.assertNotIn("recuperacao_id", self.client.session)
            self.assertFalse(RecuperacaoSenha.objects.exists())

    def test_flag_legada_nao_autoriza(self):
        self.iniciar()
        session = self.client.session
        session["codigo_validado"] = True
        session.save()
        response = self.client.get(reverse("recuperar_senha3"))
        self.assertRedirects(response, reverse("recuperar_senha"), fetch_redirect_response=False)

    def test_outra_sessao_nao_herda_validacao(self):
        self.validar()
        response = Client().get(reverse("recuperar_senha3"))
        self.assertRedirects(response, reverse("recuperar_senha"), fetch_redirect_response=False)

    def test_novo_codigo_em_outra_sessao_revoga_recuperacao_antiga(self):
        self.validar()
        Client().post(reverse("recuperar_senha"), {"email": self.pessoa.email_clientes})
        response = self.client.get(reverse("recuperar_senha3"))
        self.assertRedirects(response, reverse("recuperar_senha"), fetch_redirect_response=False)

    def test_senhas_invalidas_preservam_fluxo_e_senha(self):
        self.validar()
        for senha, confirmacao in (("", ""), ("Curta1", "Curta1"), ("semmaiuscula1", "semmaiuscula1"),
                                    ("SemNumero", "SemNumero"), ("Valida123", "Diferente1")):
            response = self.client.post(reverse("recuperar_senha3"), {"senha": senha, "confirmar_senha": confirmacao})
            self.assertEqual(response.status_code, 200)
            self.assertIn("erro", response.context)
        self.assertSenhaOriginal()

    def test_codigo_nao_exposto_no_serializer_ou_str(self):
        registro = self.iniciar()
        self.assertNotIn("codigo", RecuperacaoSenhaSerializer(registro).data)
        self.assertNotIn(registro.codigo, str(registro))

    def test_api_recuperacao_preserva_contrato_sem_logs_de_codigo(self):
        output = StringIO()
        with redirect_stdout(output):
            response = self.client.post("/api/esqueci-senha/", {"email": self.pessoa.email_clientes})
            self.assertEqual(response.status_code, 201)
            registro = RecuperacaoSenha.objects.latest("id")
            self.assertNotContains(response, registro.codigo, status_code=201)
            response = self.client.post("/api/validar-codigo/", {"email": self.pessoa.email_clientes, "codigo": registro.codigo})
            self.assertEqual(response.status_code, 200)
            response = self.client.post("/api/redefinir-senha/", {"email": self.pessoa.email_clientes,
                                        "codigo": registro.codigo, "senha": "NovaSenha1", "confirmar_senha": "NovaSenha1"})
            self.assertEqual(response.status_code, 200)
        self.assertNotIn(registro.codigo, output.getvalue())
        self.assertFalse(RecuperacaoSenha.objects.exists())

    def test_pagamento_direto_get_post_e_parametros_nao_selecionam(self):
        self.login()
        for method in (self.client.get, self.client.post):
            response = method(reverse("confirmar_socio", args=[self.plano.pk]), {"plano_id": self.plano.pk})
            self.assertRedirects(response, reverse("socio"), fetch_redirect_response=False)
        self.pessoa.refresh_from_db()
        self.assertEqual(self.pessoa.categoria_cliente_id_categoria_cliente_id, 5)

    def test_pagamento_anonimo_exige_login(self):
        for rota in ("confirmar_socio", "selecionar_plano_socio"):
            response = self.client.post(reverse(rota, args=[self.plano.pk]))
            self.assertRedirects(response, reverse("login"), fetch_redirect_response=False)

    def test_selecao_exige_post_e_csrf(self):
        self.login()
        url = reverse("selecionar_plano_socio", args=[self.plano.pk])
        self.assertEqual(self.client.get(url).status_code, 405)
        strict_client = Client(enforce_csrf_checks=True)
        self.login(strict_client)
        self.assertEqual(strict_client.post(url).status_code, 403)
        response = strict_client.get(reverse("socio"))
        self.assertContains(response, url)
        token = strict_client.cookies["csrftoken"].value
        response = strict_client.post(url, {"csrfmiddlewaretoken": token})
        self.assertEqual(response.status_code, 302)
        self.assertEqual(strict_client.post(reverse("confirmar_socio", args=[self.plano.pk])).status_code, 403)

    def test_planos_invalidos_e_nao_socio_bloqueados(self):
        self.login()
        for plano_id in (5, 999999):
            response = self.client.post(reverse("selecionar_plano_socio", args=[plano_id]))
            self.assertRedirects(response, reverse("socio"), fetch_redirect_response=False)
            self.assertNotIn("selecao_socio", self.client.session)

    def test_trocar_id_na_url_bloqueia_get_e_post(self):
        for method in (self.client.get, self.client.post):
            self.selecionar()
            response = method(reverse("confirmar_socio", args=[self.outro_plano.pk]))
            self.assertRedirects(response, reverse("socio"), fetch_redirect_response=False)

    def test_selecao_expirada_ou_de_outro_cliente_bloqueada(self):
        for alteracao in ({"criado_em": (timezone.now()-timedelta(hours=1)).timestamp()}, {"cliente_id": 9999}):
            self.selecionar()
            session = self.client.session
            session["selecao_socio"] = {**session["selecao_socio"], **alteracao}
            session.save()
            response = self.client.get(reverse("confirmar_socio", args=[self.plano.pk]))
            self.assertRedirects(response, reverse("socio"), fetch_redirect_response=False)

    def test_plano_removido_apos_selecao_bloqueado(self):
        self.selecionar()
        # DELETE SQL evita coletar relacoes externas unmanaged fora deste teste.
        with connection.cursor() as cursor:
            cursor.execute("DELETE FROM categoria_cliente WHERE id_CATEGORIA_CLIENTE = %s", [self.plano.pk])
        response = self.client.post(reverse("confirmar_socio", args=[self.plano.pk]))
        self.assertRedirects(response, reverse("socio"), fetch_redirect_response=False)

    def test_fluxo_socio_completo_consume_selecao(self):
        self.selecionar()
        url = reverse("confirmar_socio", args=[self.plano.pk])
        response = self.client.get(url)
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.context["plano"].pk, self.plano.pk)
        self.assertIn("no-store", response.headers["Cache-Control"])
        response = self.client.post(url, {"paypal": "1", "plano_id": self.outro_plano.pk})
        self.assertRedirects(response, reverse("home"), fetch_redirect_response=False)
        self.pessoa.refresh_from_db()
        self.assertEqual(self.pessoa.categoria_cliente_id_categoria_cliente_id, self.plano.pk)
        self.assertEqual(self.client.session["plano_socio_id"], self.plano.pk)
        self.assertNotIn("selecao_socio", self.client.session)
        self.assertRedirects(self.client.post(url), reverse("socio"), fetch_redirect_response=False)
