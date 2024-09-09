<?php
include("conexao.php");

if (isset($_POST["cpf"]) or isset($_POST["nome"]) or isset($_POST["data_nasc"])){
    $cpf = $_POST["cpf"];
    $nome = $_POST["nome"];
    $data_nasc = $_POST["data_nasc"];

    $sqlGrava = mysqli_query($conexao, "insert into usuario (cpf, nome, data_nasc)
                 values ('$cpf', '$nome', '$data_nasc')");
    header('Location: banco.php');             
}
?>