<?php
include("conexao.php");
include("menu.php");
$cpf = $_GET["cpf"];
$sqlBusca = mysqli_query($conexao, "select * from usuario where cpf = '$cpf'") or die('Erro');

if($sqlBusca != null){
    $dados = mysqli_fetch_array($sqlBusca);
    if($dados){
        $cpf = $dados['cpf'];
        $nome = $dados['nome'];
        $data_nasc = $dados['data_nasc'];
        echo "CPF: $cpf | Nome: $nome | Data de Nascimento: $data_nasc</br>";
    }
    else{
        echo("CPF não encontrado!</br>");
    }
} else{
    echo("CPF não encontrado!</br>");
}

?>