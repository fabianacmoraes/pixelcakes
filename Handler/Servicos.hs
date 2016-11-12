{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
module Handler.Servicos where

import Foundation
import Yesod
import Data.Text
import Control.Applicative
import Database.Persist.Postgresql

formServ :: Form Servicos
formServ = renderDivs $ Servicos
    <$> areq textField "Serviço oferecido: "      Nothing
    <*> areq textField "Descrição do serviço: "   Nothing

getServicoR :: Handler Html
getServicoR = do
            (widget, enctype) <- generateFormPost formServ
            defaultLayout $ do
                setTitle "Administrator | Pixel Cakes"
                addStylesheetRemote "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
                addStylesheetRemote "https://fonts.googleapis.com/css?family=Raleway"
                addStylesheet $ StaticR css_main_css
                addScriptRemote "https://code.jquery.com/jquery-3.1.1.min.js"
                addScriptRemote "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"
                addScript $ StaticR js_main_js
                [whamlet|
                    <div class="container">
                        <img src=@{StaticR img_logo_png} alt="Logo Pixel Cakes" class="center-block" id="imglogin">
                        <nav class="navbar navbar-default" id="navbar-admin">
                            <div class="container-fluid">
                                <div class="navbar-header">
                                    <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
                                        <span class="sr-only">Navegação alternativa
                                        <span class="icon-bar">
                                        <span class="icon-bar">
                                        <span class="icon-bar">
        
                                <div id="navbar" class="navbar-collapse collapse">
                                    <ul class="nav navbar-nav">
                                        <li>
                                            <a href=@{PerfilR}>home
                                        <li class="dropdown active">
                                            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
                                                serviços <span class="caret">
                                            <ul class="dropdown-menu">
                                                <li>
                                                    <a href=@{ServicoR}>
                                                        <span class="glyphicon glyphicon-plus"></span>
                                                        adicionar
                                                
                                                <li role="separator" class="divider"></li>
                                                <li>
                                                    <a href=@{ListServR}>
                                                        <span class="glyphicon glyphicon-th-list"></span>
                                                        ver todos
                                        <li class="dropdown">
                                            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
                                                produtos <span class="caret">
                                            <ul class="dropdown-menu">
                                                <li>
                                                    <a href=@{ProdutoR}>
                                                        <span class="glyphicon glyphicon-plus"></span>
                                                        adicionar
                                                
                                                <li role="separator" class="divider"></li>
                                                <li>
                                                    <a href=@{ListProdR}>
                                                        <span class="glyphicon glyphicon-th-list"></span>
                                                        ver todos
                                        <li>
                                            <a href=@{ListContR}>contatos
                                        <li class="dropdown">
                                            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
                                                usuários <span class="caret">
                                            <ul class="dropdown-menu">
                                                <li>
                                                    <a href=@{UsuarioR}>
                                                        <span class="glyphicon glyphicon-plus"></span>
                                                        adicionar
                                                
                                                <li role="separator" class="divider"></li>
                                                <li>
                                                    <a href="#">
                                                        <span class="glyphicon glyphicon-th-list"></span>
                                                        ver todos
                                    <ul class="nav navbar-nav navbar-right">
                                        <li>
                                            <form action=@{LogoutR} method=post>
                                                <input type="submit" value="sair" class="btn-sair">
                        <h2>Cadastrar serviço</h2>
                        <form method=post action=@{ServicoR} enctype=#{enctype}>
                            ^{widget}
                            <input type="submit" value="Cadastrar" class="btn btn-default">
         |]

postServicoR :: Handler Html
postServicoR = do
            ((result, _), _) <- runFormPost formServ
            case result of
                FormSuccess servicos -> do
                    did <- runDB $ insert servicos
                    defaultLayout [whamlet|
                        Serviço cadastrado com sucesso #{fromSqlKey did}!
                    |]
                _ -> redirect HomeR

getListServR :: Handler Html
getListServR = do
            servicos <- runDB $ selectList [] [Asc ServicosNome]
            defaultLayout $ do
                [whamlet|
                    <table>
                        <tr> 
                            <td> id  
                            <td> nome 
                            <td> descricao
                        $forall Entity did serv <- servicos
                            <tr> 
                                <form action=@{DelServicoR did} method=post> 
                                    <td> #{fromSqlKey  did}  
                                    <td> #{servicosNome  serv}
                                    <td> #{servicosDescricao  serv}
                                    <td> <input type="submit" value="excluir">
                    |]

postDelServicoR :: ServicosId -> Handler Html
postDelServicoR did = do 
                runDB $ delete did
                redirect ListServR