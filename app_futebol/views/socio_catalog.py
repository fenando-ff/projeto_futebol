import json
from functools import lru_cache
from decimal import Decimal
from pathlib import Path

from ..models import CategoriaCliente
from .helpers import build_public_image_url


_SOCIO_TIER_BY_ID = {
    2: "diamante",
    3: "ouro",
    4: "prata",
    5: "nao-socio",
}

_SOCIO_DISCOUNT_BY_TIER = {
    "diamante": 20,
    "ouro": 10,
    "prata": 5,
    "nao-socio": 0,
}


def _catalog_path():
    return Path(__file__).with_name("socio_data.json")


@lru_cache(maxsize=1)
def _load_raw_catalog():
    try:
        with _catalog_path().open("r", encoding="utf-8") as handle:
            raw_catalog = json.load(handle)
    except FileNotFoundError:
        return {}

    catalog = {}
    for item in raw_catalog:
        try:
            item_id = int(item.get("id"))
        except (TypeError, ValueError):
            continue

        catalog[item_id] = {
            "id": item_id,
            "nome": item.get("nome") or "",
            "preco": item.get("preco"),
            "imagem": item.get("imagem") or "",
            "beneficios": item.get("beneficios") or [],
        }

    return catalog


def get_socio_catalog_item(categoria_id):
    try:
        categoria_id = int(categoria_id)
    except (TypeError, ValueError):
        return {}

    return _load_raw_catalog().get(categoria_id, {})


def get_socio_catalog_order():
    return list(_load_raw_catalog().values())


def get_socio_tier(categoria):
    categoria_id = getattr(categoria, "id_categoria_cliente", None)
    nome = (getattr(categoria, "nome_categoria_clientes", "") or "").strip().lower()

    if categoria_id in _SOCIO_TIER_BY_ID:
        return _SOCIO_TIER_BY_ID[categoria_id]

    if "diamante" in nome:
        return "diamante"
    if "ouro" in nome:
        return "ouro"
    if "prata" in nome:
        return "prata"
    return "nao-socio"


def get_socio_desconto_percent(categoria):
    return _SOCIO_DISCOUNT_BY_TIER.get(get_socio_tier(categoria), 0)


def build_socio_web_plan(categoria):
    catalog_item = get_socio_catalog_item(getattr(categoria, "id_categoria_cliente", None))

    return {
        "id": getattr(categoria, "id_categoria_cliente", None),
        "nome": getattr(categoria, "nome_categoria_clientes", None),
        "preco": float(getattr(categoria, "preco_categ", 0) or 0),
        "imagem": catalog_item.get("imagem") or "",
        "beneficios": catalog_item.get("beneficios") or [],
    }


def build_socio_api_plan(categoria):
    catalog_item = get_socio_catalog_item(getattr(categoria, "id_categoria_cliente", None))
    desconto_percent = get_socio_desconto_percent(categoria)
    preco = float(getattr(categoria, "preco_categ", 0) or 0)
    nome = getattr(categoria, "nome_categoria_clientes", "") or ""
    descricao = getattr(categoria, "descricao_categ_cli", "") or ""
    imagem = catalog_item.get("imagem") or ""
    beneficios = catalog_item.get("beneficios") or []

    return {
        "id": getattr(categoria, "id_categoria_cliente", None),
        "plano_id": getattr(categoria, "id_categoria_cliente", None),
        "title": nome,
        "nome": nome,
        "nome_plano": nome,
        "description": descricao,
        "descricao": descricao,
        "price": preco,
        "valor": preco,
        "preco": preco,
        "card_image": build_public_image_url(imagem),
        "card_image_path": imagem,
        "imagem": imagem,
        "beneficios": beneficios,
        "vagas": catalog_item.get("vagas"),
        "tier": get_socio_tier(categoria),
        "status": "nao_socio" if get_socio_tier(categoria) == "nao-socio" else "ativa",
        "is_socio": get_socio_tier(categoria) != "nao-socio",
        "ativo": get_socio_tier(categoria) != "nao-socio",
        "desconto_percent": desconto_percent,
        "desconto_label": f"{desconto_percent}% de desconto em produtos oficiais" if desconto_percent else "Sem desconto exclusivo",
        "desconto_valor_exemplo": round(preco * (desconto_percent / 100), 2) if desconto_percent else 0.0,
        "id_categoria_cliente": getattr(categoria, "id_categoria_cliente", None),
        "nome_categoria_clientes": nome,
        "descricao_categ_cli": descricao,
        "preco_categ": preco,
    }


def _as_decimal(value):
    return Decimal(str(value or 0))


def _quantize_money(value):
    return _as_decimal(value).quantize(Decimal("0.01"))


def build_pricing_snapshot(preco_base, categoria_cliente=None, quantidade=1):
    desconto_percent = get_socio_desconto_percent(categoria_cliente)
    preco_original_unitario = _quantize_money(preco_base)
    desconto_decimal = _as_decimal(desconto_percent) / Decimal("100")
    preco_final_unitario = (preco_original_unitario * (Decimal("1") - desconto_decimal)).quantize(Decimal("0.01"))
    economia_unitaria = (preco_original_unitario - preco_final_unitario).quantize(Decimal("0.01"))
    quantidade_decimal = _as_decimal(quantidade if quantidade is not None else 1)
    preco_original_total = (preco_original_unitario * quantidade_decimal).quantize(Decimal("0.01"))
    preco_final_total = (preco_final_unitario * quantidade_decimal).quantize(Decimal("0.01"))
    economia_total = (preco_original_total - preco_final_total).quantize(Decimal("0.01"))

    return {
        "desconto_percent": desconto_percent,
        "preco_original_unitario": float(preco_original_unitario),
        "preco_final_unitario": float(preco_final_unitario),
        "economia_unitaria": float(economia_unitaria),
        "preco_original_total": float(preco_original_total),
        "preco_final_total": float(preco_final_total),
        "economia_total": float(economia_total),
    }


def get_socio_planos_queryset():
    return CategoriaCliente.objects.all().order_by("id_categoria_cliente")
