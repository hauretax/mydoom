/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   hms_parser_tex.c                                   :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: hutricot <hutricot@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2019/09/12 11:39:49 by pitriche          #+#    #+#             */
/*   Updated: 2020/02/04 14:25:45 by hutricot         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "doom_nukem.h"

int		parse_pixels(t_tex *tex, int fd)
{
    printf("Allocating memory for pixels: %u x %u\n", tex->size_x, tex->size_y);
    if (!(tex->pix = ft_memalloc(tex->size_x * tex->size_y * sizeof(int))))
    {
        printf("Failed to allocate memory for pixels\n");
        exit(pr_err(MERROR_MESS));
    }
    printf("Reading pixel data from file\n");
    ssize_t bytes_read = read(fd, tex->pix, tex->size_x * tex->size_y * sizeof(int));
    printf("Bytes read for pixels: %zd (expected: %zu)\n", bytes_read, tex->size_x * tex->size_y * sizeof(int));
    if (bytes_read != tex->size_x * tex->size_y * sizeof(int))
    {
        printf("Failed to read pixel data\n");
        return (1);
    }
    printf("Pixel data successfully read\n");
    return (0);
}

int		parse_texture(t_tex *tex, int fd)
{
    unsigned char buf[16];

    printf("Reading texture header (16 bytes)\n");
    if (read(fd, buf, 16) != 16)
    {
        printf("Failed to read texture header\n");
        return (1);
    }
    tex->size_x = buf[0] | (buf[1] << 8) | (buf[2] << 16) | (buf[3] << 24);
	tex->size_y = buf[4] | (buf[5] << 8) | (buf[6] << 16) | (buf[7] << 24);
    printf("Texture size: %u x %u\n", tex->size_x, tex->size_y);
    if (!tex->size_x || !tex->size_y)
    {
        printf("Texture has null size\n");
        return (pr_err("Null sized texture\n"));
    }
    printf("Parsing pixels for texture\n");
    if (parse_pixels(tex, fd))
    {
        printf("Failed to parse pixels for texture\n");
        return (1);
    }
    printf("Texture successfully parsed\n");
    return (0);
}

int		parse_textures(t_al *al, int fd)
{
    unsigned char	buf[16];
    unsigned int	i;

    printf("Reading number of textures (16 bytes)\n");
    if (read(fd, buf, 16) != 16)
    {
        printf("Failed to read number of textures\n");
        return (1);
    }
    al->nb_tex = *(unsigned short *)buf;
    printf("Number of textures: %u\n", al->nb_tex);
    if (!(al->tex = ft_memalloc((al->nb_tex + 1) * sizeof(t_tex))))
    {
        printf("Failed to allocate memory for textures\n");
        exit(pr_err(MERROR_MESS));
    }
    i = 0;
    while (i <= al->nb_tex)
    {
        printf("Parsing texture %u/%u\n", i + 1, al->nb_tex + 1);
        if (parse_texture(al->tex + i, fd))
        {
            printf("Failed to parse texture %u\n", i + 1);
            return (1);
        }
        printf("Texture %u successfully parsed\n", i + 1);
        i++;
    }
    printf("All textures successfully parsed\n");
    return (0);
}