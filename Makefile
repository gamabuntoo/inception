NAME=inception
UID= $(shell id -u)
GID= $(shell id -g)

all: $(NAME)

$(NAME):
	cd srcs/ && docker compose up --build

clean:
	cd srcs/ && docker compose down -v --remove-orphans

fclean: 
# 	cd srcs/ && docker compose exec -u root mariadb rm -rf /var/lib/mysql/*
# 	cd srcs/ && docker compose exec -u root wordpress rm -rf /var/www/html/*
	cd srcs/ && docker compose down -v --remove-orphans
	cd srcs/ && sudo chown -R $(UID):$(GID) data/ 
	cd srcs/data/mariadb/ && rm -rf *
	cd srcs/data/wordpress/ && rm -rf *
	cd srcs/ && docker system prune -af --volumes

re: 	
	$(MAKE) fclean
	$(MAKE) all

.PHONY: clean fclean re