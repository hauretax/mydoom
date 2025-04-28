NAME = doom_nukem

CC = gcc
CCF = -fsanitize=address
OPT_FLAGS = -flto -O3
BUG_FLAGS = -g
FLAGS = -Wall -Wextra

PWD = $(shell pwd)
LIBFT_DIR = ./libft/
LIBFT_HEAD = $(LIBFT_DIR)
LIBFT = $(LIBFT_DIR)libft.a
LIBRARIES = -L$(LIBFT_DIR) -lft

HEADERS_DIR = ./includes/
HEADERS_LIST = doom_nukem.h
INCLUDES = -I$(HEADERS_DIR) -I$(LIBFT_HEAD)

# Utilisation directe de MSYS2 installation SDL2/SDL2_image/SDL2_mixer
SDL_FLAGS = -IC:/msys64/mingw64/include/SDL2 -LC:/msys64/mingw64/lib -lmingw32 -lSDL2main -lSDL2 -lSDL2_image -lSDL2_ttf -lSDL2_mixer

SRC_DIR = ./srcs/
OBJ_DIR = obj/
#init_two.c 				
#		init_troy.c 			
SRC_LIST = arrow_edit.c		\
		add_edit.c			\
		angles.c			\
		bad_pig.c			\
		bmp_to_tex.c		\
		choose_tex.c		\
		column_hits.c		\
		column_linesaver.c	\
		column_utils.c		\
		column.c			\
		draw_edit_tools.c	\
		draw_tools.c		\
		edit_link_sectors.c	\
		edit_to_game.c		\
		edit.c				\
		event_func.c		\
		ft_dtoa_doom.c		\
		finish.c			\
		game_disp.c			\
		game.c				\
		dead.c				\
		get_map.c			\
		get_map_two.c		\
		hms_parser.c		\
		hms_parser_sec.c	\
		hms_parser_tex.c	\
		hms_parser_texgp.c	\
		hms_encoder.c		\
		hms_encoder_sec.c	\
		hms_encoder_tex.c	\
		hms_encoder_texgp.c	\
		ia.c				\
		init.c 				\
		init_two.c			\
		init_troy.c			\
		main_loop.c 		\
		main.c				\
		mob_disp.c			\
		mob_moov.c			\
		mouse_edit_stat.c	\
		mouse_edit.c		\
		mouse_event_funk.c	\
		pewpew.c			\
		pimp_cross.c		\
		player_moov.c		\
		refresh_text.c		\
		rectanle_menu.c		\
		refresh.c			\
		render_cast.c		\
		render_minimap.c	\
		render_test.c		\
		render_utils.c		\
		render.c			\
		sdl_tools.c			\
		sector.c			\
		spawn.c				\
		set_edit.c			\
		sport_physics.c		\
		texte.c				\
		tool_add_edit.c		\
		tool_arrow.c		\
		tool_text.c			\
		tools.c				\
		won.c				\
		yeet_text.c			\
		yeet.c



SRC = $(addprefix $(SRC_DIR), $(SRC_LIST))
OBJ_LIST = $(patsubst %.c, %.o, $(SRC_LIST))
OBJ = $(addprefix $(OBJ_DIR), $(OBJ_LIST))

YELLOW = \033[0;33m
GREEN = \033[0;32m
BLUE = \033[0;36m
RED = \033[0;31m
PURPLE = \033[0;35m
RESET = \033[0m

all: $(NAME)

$(NAME): $(LIBFT) $(OBJ_DIR) $(OBJ)
	@echo "$(YELLOW)Sources compilation $(RESET)[$(GREEN)OK$(RESET)]\n"
	@$(CC) $(FLAGS) $(OPT_FLAGS) $(INCLUDES) $(OBJ) $(LIBRARIES) $(SDL_FLAGS) -lm -o $(NAME)
	@echo "[$(BLUE)$(NAME) Compiled$(RESET)]"

$(OBJ_DIR):
	@mkdir -p $(OBJ_DIR)
	@echo "\n$(BLUE)Obj directory...$(RESET)[$(GREEN)created$(RESET)]\n"

$(OBJ_DIR)%.o: $(SRC_DIR)%.c $(HEADERS)
	@$(CC) $(FLAGS) $(OPT_FLAGS) $(INCLUDES) -c $< -o $@
	@echo "$(YELLOW)$(notdir $(basename $@))...$(RESET)[$(GREEN)OK$(RESET)]"

$(LIBFT):
	@$(MAKE) -sC $(LIBFT_DIR)

fast: all
	./doom_nukem house.hms

clean:
	@$(MAKE) -sC $(LIBFT_DIR) clean
	@rm -rf $(OBJ_DIR)
	@echo "\n$(RED)Obj directory...$(RESET)[$(PURPLE)deleted$(RESET)]\n"

fclean: clean
	@rm -f $(LIBFT)
	@echo "$(RED)Libft...$(RESET)[$(PURPLE)deleted$(RESET)]\n"
	@rm -f $(NAME)
	@echo "$(RED)$(NAME)...$(RESET)[$(PURPLE)deleted$(RESET)]\n"

sani: $(LIBFT) $(OBJ_DIR) $(OBJ)
	@echo "$(YELLOW)Sources compilation $(RESET)[$(GREEN)OK$(RESET)]\n"
	@$(CC) $(CCF) $(FLAGS) $(INCLUDES) $(OBJ) $(LIBRARIES) $(SDL_FLAGS) -lm -o $(NAME)
	@echo "[$(BLUE)$(NAME) Compiled with sanitizer$(RESET)]"

bug: $(LIBFT) $(OBJ_DIR) $(OBJ)
	@echo "$(YELLOW)Sources compilation $(RESET)[$(GREEN)OK$(RESET)]\n"
	@$(CC) $(FLAGS) $(OPT_FLAGS) $(INCLUDES) $(OBJ) $(LIBRARIES) $(SDL_FLAGS) -lm -g -o $(NAME)
	@echo "[$(BLUE)$(NAME) Compiled for debugging$(RESET)]"
	lldb ./doom_nukem house.hms

re: fclean all

.PHONY: all clean fclean re sani bug fast