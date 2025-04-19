#include <SDL2/SDL.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

void dessinerRectangle(SDL_Renderer *renderer, SDL_Color couleur, int largeur, int hauteur) {
    SDL_SetRenderDrawColor(renderer, couleur.r, couleur.g, couleur.b, 255);
    SDL_Rect rect = {400 - largeur/2, 300 - hauteur/2, largeur, hauteur};
    SDL_RenderFillRect(renderer, &rect);
}

void dessinerTriangle(SDL_Renderer *renderer, SDL_Color couleur, int base, int hauteur) {
    SDL_SetRenderDrawColor(renderer, couleur.r, couleur.g, couleur.b, 255);
    // Centre du triangle en (400,300)
    int x1 = 400;
    int y1 = 300 - hauteur/2;
    int x2 = 400 - base/2;
    int y2 = 300 + hauteur/2;
    int x3 = 400 + base/2;
    int y3 = 300 + hauteur/2;
    SDL_RenderDrawLine(renderer, x1, y1, x2, y2);
    SDL_RenderDrawLine(renderer, x2, y2, x3, y3);
    SDL_RenderDrawLine(renderer, x3, y3, x1, y1);
}

void dessinerCercle(SDL_Renderer *renderer, SDL_Color couleur, int cx, int cy, int rayon) {
    SDL_SetRenderDrawColor(renderer, couleur.r, couleur.g, couleur.b, 255);
    for (int w = 0; w < rayon * 2; w++) {
        for (int h = 0; h < rayon * 2; h++) {
            int dx = rayon - w;
            int dy = rayon - h;
            if (dx * dx + dy * dy <= rayon * rayon) {
                SDL_RenderDrawPoint(renderer, cx + dx, cy + dy);
            }
        }
    }
}

SDL_Color choisirCouleur(int choix) {
    SDL_Color couleurs[] = {
        {0, 0, 0},       // noir
        {255, 0, 0},     // rouge
        {0, 255, 0},     // vert
        {255, 255, 0},   // jaune
        {0, 0, 255},     // bleu
        {255, 0, 255},   // magenta
        {0, 255, 255},   // cyan
        {255, 255, 255}  // blanc
    };
    if (choix >= 1 && choix <= 8)
        return couleurs[choix - 1];
    else
        return (SDL_Color){255, 255, 255};
}

int main() {
    if (SDL_Init(SDL_INIT_VIDEO) != 0) {
        printf("Erreur SDL: %s\n", SDL_GetError());
        return 1;
    }

    SDL_Window *window = SDL_CreateWindow("Dessin Automatique",
                    SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 800, 600, 0);

    SDL_Renderer *renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);
    SDL_SetRenderDrawColor(renderer, 255, 255, 255, 255);
    SDL_RenderClear(renderer);

    SDL_Color couleur = choisirCouleur(1); // Couleur 1

    // Dessiner un rectangle de taille 10 avec couleur 1
    dessinerRectangle(renderer, couleur, 10 * 30, 10 * 20);

    SDL_RenderPresent(renderer);

    SDL_Event e;
    int quit = 0;
    while (!quit) {
        while (SDL_PollEvent(&e)) {
            if (e.type == SDL_QUIT)
                quit = 1;
        }
    }

    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();

    return 0;
}
