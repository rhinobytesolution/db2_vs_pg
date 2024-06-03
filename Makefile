start:
	docker compose down --timeout 0 &&\
	docker compose up -d &&\
	docker compose logs --tail=0 -f

iex_gen_game:
	docker compose exec gen_game iex --sname remote \
		--cookie g3ng4m3 \
		--remsh gen_game

console_gen_game:
	docker compose exec gen_game bash

restart_app:
	docker compose stop gen_game --timeout 0 &&\
	docker compose up -d
