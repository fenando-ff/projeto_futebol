let user = prompt("Digite um usuário:");
let password = prompt("Digite uma senha:");
const confUser = "fernando"
const confPassword = "fernando123"

if(user === confUser && password === confPassword){
    alert("Login realizado com sucesso ✅");
} else if(user === confUser && password !== confPassword){
    alert("Senha não confere ❌");
} else if(user !== confUser && password === confPassword){
    alert("Usuário não confere ❌");
}
else {
    alert("Acesso Negado ❌")
}