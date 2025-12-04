
function login() {
    let user = document.getElementById("email").value;
    let password = document.getElementById("senha").value;
    let aviso = document.getElementById("aviso");

    let confUser = "fernando"
    let confPassword = "fernando123"

    if (user === confUser && password === confPassword){
        aviso.style.color = "#2aff6d";
        aviso.innerHTML = "Login realizado com sucesso ✅";
    } else if ((user == "" || password == "") || (user == "" && password == "")) {
        aviso.style.color = "#fffc46ff";
        aviso.innerHTML = "Preencha todos os campos!";
    } else if (user === confUser && password !== confPassword) {
        aviso.style.color = "#ff4646ff";
        aviso.innerHTML = "Senha não confere ❌";
    } else if (user !== confUser && password === confPassword){
        aviso.style.color = "#ff4646ff";
        aviso.innerHTML = "Usuário não confere ❌";
    } else {
        aviso.style.color = "#ff4646ff";
        aviso.innerHTML = "Acesso Negado ❌";
    };

};

