<?php
include("conexao.php");

if (isset($conexao)){
    echo "Banco de dados selecionado com sucesso!";
}

include("menu.php");

$sqlUsuarios = mysqli_query($conexao, "select * from usuario") or die("Erro!");

$numLinhas =  mysqli_num_rows($sqlUsuarios);

for($i = 0; $i < $numLinhas; $i++){
    $dados = mysqli_fetch_array($sqlUsuarios);

    $cpf = $dados['cpf'];
    $nome = $dados['nome'];
    $data_nasc = $dados['data_nasc'];

    echo "CPF: $cpf | Nome: $nome | Data de Nascimento: $data_nasc</br>";
}
//$pesquisaCPF = $_GET['cpf'];

?>

<html>
    <head>
        <title>Cadastro de Usuário</title>
    </head>

    <body>
        <h1>Cadastro de Usuário</h1>
        <form action="recebe-dados.php" method="post">
            CPF: <input type="text" name="cpf"></br>
            Nome: <input type="text" name="nome"></br>
            Data de Nascimento: <input type="text" name="data_nasc"></br>
            <input type="submit" value="Enviar dados">
        </form>
    </body>

</html>