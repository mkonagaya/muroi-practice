IS_WSL := $(shell grep -qi microsoft /proc/version && echo 1 || echo 0)

# 今後、Macユーザが来たときのための分岐処理を定義しておく。
os:
	ifeq ($(IS_WSL),1)
		@echo "This is running under WSL."
	else
		@echo "This is not running under WSL."
	endif

dc-up:
	@docker compose up -d
dc-down:
	@docker compose down
re-cache:
	@docker compose exec -u1000:1000 app php artisan route:clear
	@docker compose exec app php artisan cache:clear
	@docker compose exec -u1000:1000 app php artisan config:clear
tinker:
	@docker compose exec app php artisan tinker
routes:
	@docker compose exec app php artisan route:list
ide-helper: migrate
	@docker compose exec -u1000:1000 app php artisan ide-helper:models -RW
db-refresh:
	@docker compose exec -u1000:1000 app php artisan migrate:refresh --seed
artisan:
	@docker compose exec -u1000:1000 app php artisan $(cmd)
make-migration:
	@docker compose exec -u1000:1000 app php artisan make:migration $(filename)
migrate:
	@docker compose exec -u1000:1000 app php artisan migrate
migrate-rollback:
	@docker compose exec -u1000:1000 app php artisan migrate:rollback
test:
	@docker compose exec -u1000:1000 app php artisan prepare_test_and_run
test-filter:
	@docker compose exec -u1000:1000 app php artisan prepare_test_and_run --filter=$(filter)
create-hotfix:
	@git switch develop
	@git pull origin develop
	@git switch -C hotfix
	@git branch --contains=HEAD
push-hotfix:
	@git switch develop
	@git merge hotfix
	@git push origin develop
	@git branch -d hotfix
	@git branch --contains=HEAD
gdev:
	@git switch develop
	@git pull origin develop
gallfetch: gdev
	@git fetch --tags --prune -v
	@git pull origin
	@git branch -vv | grep ': gone]' | awk '{print $$1}' | xargs -r -n 1 git branch -d
	@git branch --contains=HEAD
composer-update:
	@docker compose exec -u1000:1000 app composer install
create-factory:
	@docker compose exec -u1000:1000 app php artisan make:factory $(factory)
	@docker compose exec -u1000:1000 app php artisan ide-helper:models -RW