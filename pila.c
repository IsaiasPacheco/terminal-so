#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include "pila.h"


/*
 * Inicializamos la estructura de la pila, ponemos el valor de frente en NULL y el contador de objetos en 0
 */
int crear(struct pila *p) {
	p->frente = NULL;
	p->tamano = 0;
	return 1;
}

int push(struct pila *p, struct elemento elemento){
	
	struct elemento *nuevo = (struct elemento *) malloc(sizeof(struct elemento));
	if (nuevo == NULL) { return -1; }
	strcpy(nuevo->ruta, elemento.ruta);
	nuevo->next = NULL;
	
	nuevo->next = p->frente;
	p->frente = nuevo;
	p->tamano++;
	return 1;
}

int pop(struct pila *p, struct elemento *elemento){
	// si la pila esta vacia retornamos -1
	if (estaVacia(*p) ) { return -1; }
	// COPIAMOS el dato a retornar al usuario.
    strcpy(elemento->ruta, p->frente->ruta);
	//elemento->dato = p->frente->dato;
	p->frente = p->frente->next;
	p->tamano--;
}

void impPila(struct pila *p){
    printf("Imprimiendo [%d] ? [%d]..\n", p->tamano, estaVacia(*p));
    struct elemento aux;
    while(!estaVacia(*p)){
        pop(p, &aux);
        printf(", %s", aux.ruta);
    }
}

int estaVacia(struct pila p){
	if (p.tamano == 0) { return 1; }
	//if (p.frente == NULL) { return 1; }
	return 0;
}

int tamano(struct pila p){
	return p.tamano;
}