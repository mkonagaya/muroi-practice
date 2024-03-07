# Bayer Central

イーウーパスポート様 物流管理システム

## スタック

Laravel9

### Laravel

#### コマンド実行 (WSL2 in Windows)

`docker compose exec -u1000:1000 app bash`

## Build & Up

```docker compose up -d --build```

## コンテナ起動状態を確認

```docker compose ps```  
コンテナが4つ立ち上がっていればOK

## Package Install

appコンテナに入る

```
docker compose exec -u1000:1000 app bash
```

## Laravelプロジェクト作成

### `/.composer/config.json` を作成する (WSL)

```shell
docker compose exec app bash
```

```shell
mkdir /.composer

touch /.composer/config.json

echo "{}" > /.composer/config.json

chown 1000:1000 -R /.composer

chown 1000:1000 -R /app
```

```shell
docker compose exec -u1000:1000 app bash

composer create-project --prefer-dist laravel/laravel . "9.x"
```

```shell
docker compose exec -u1000:1000 app composer require --dev barryvdh/laravel-ide-helper

# 認証
docker compose exec -u1000:1000 app composer require laravel/sanctum
docker compose exec -u1000:1000 app php artisan vendor:publish --provider="Laravel\Sanctum\SanctumServiceProvider"
docker compose exec -u1000:1000 app php artisan migrate
```

### cloneしたら

```shell
# migrate
docker compose exec -u1000:1000 app php artisan migrate
# composer
docker compose exec -u1000:1000 app composer install
# generate key
docker compose exec -u1000:1000 app php artisan key:generate
```

## 権限設定

### 初期コマンド、強制変更コマンド

```shell
docker compose exec app chmod 2777 -R ./storage
```

### 設定ファイル（推奨）

`config/logging.php`

`channels`配下の`permission`を追加。

```php
        'daily' => [
            'driver' => 'daily',
            'path' => storage_path('logs/laravel.log'),
            'level' => env('LOG_LEVEL', 'debug'),
            'days' => 14,
            "permission" => 0777,
        ],
```

# 逐次コマンド

```shell 
docker compose exec -u1000:1000 app php artisan ***

# ide-helper
docker compose exec -u1000:1000 app php artisan ide-helper:models -RW
```

# クエリログTips

クエリの詳細がログに出力されます。

```php
DB::enableQueryLog();
# SQL処理
Log::debug(DB::getQueryLog());
```

# ローカルでのテスト実行について

## 準備

localでテストを実行する際に使用するテスト用DBを作成します。

テスト用のDBはDBコンテナをリビルトしてください。

```shell
# docker compose psでdbコンテナが起動していることを確認後、以下を実行。

# テスト用DBの作成
docker compose exec -T db mysql -uroot -proot -e "CREATE DATABASE db_name_test;"
docker compose exec -T db mysql -uroot -proot -e "GRANT ALL PRIVILEGES ON db_name_test.* TO 'db_user'@'%';"
docker compose exec -T db mysql -uroot -proot -e "FLUSH PRIVILEGES;"
```

## 実行

以下のカスタムコマンドを実行することで、テスト用DBのmigration + seedingを行い、テストを実行します。

初回実行時はdockerの再起動を必ず行うこと。

```shell
make test
```

test名を指定して実行

```shell
make test-filter filter=<テスト名>
```
