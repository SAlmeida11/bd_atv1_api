<?php
include("menu.php");
include("conexao.php");
?>

<html>
    <head>
        <title>Pesquisar Usuário</title>
    </head>
    <body>
        <h1>Pesquisar Usuário</h1>
        <form action="busca-dados.php" method="get">
            CPF: <input type="text" name="cpf">
            <input type="submit" value="Pesquisar dados">
        </form>
    </body>
</html>
