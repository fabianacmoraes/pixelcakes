{-# LANGUAGE OverloadedStrings, TypeFamilies, QuasiQuotes,
             TemplateHaskell, GADTs, FlexibleContexts,
             MultiParamTypeClasses, DeriveDataTypeable, EmptyDataDecls,
             GeneralizedNewtypeDeriving, ViewPatterns, FlexibleInstances #-}
module Foundation where

import Yesod
import Data.Text
import Yesod.Static
import Database.Persist.Postgresql
    ( ConnectionPool, SqlBackend, runSqlPool)

staticFiles "static"

data App = App {getStatic :: Static , connPool :: ConnectionPool }

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|
Usuario
    email Text
    senha Text

Produtos
    nome        Text
    descricao   Text
    preco       Double
    deriving Show

Servicos
    nome  Text
    descricao Text
    deriving Show
    
Contato
    nome        Text
    email       Text
    mensagem    Text
    deriving Show
|]

mkYesodData "App" $(parseRoutesFile "routes")

mkMessage "App" "messages" "pt"

type Form a = Html -> MForm Handler (FormResult a, Widget)

instance Yesod App where
    authRoute _ = Just LoginR
    
    isAuthorized IndexR _ = return Authorized
    isAuthorized LoginR _ = return Authorized
    isAuthorized ProdutosR _ = return Authorized
    isAuthorized ServicosR _ = return Authorized
    isAuthorized ContatoR _ = return Authorized
    isAuthorized UsuarioR _ = return Authorized
    isAuthorized _ _ = estaAutenticado

estaAutenticado :: Handler AuthResult
estaAutenticado = do
   msu <- lookupSession "_ID"
   case msu of
       Just _ -> return Authorized
       Nothing -> return AuthenticationRequired

instance YesodPersist App where
   type YesodPersistBackend App = SqlBackend
   runDB f = do
       master <- getYesod
       let pool = connPool master
       runSqlPool f pool

instance RenderMessage App FormMessage where
    renderMessage _ _ = defaultFormMessage