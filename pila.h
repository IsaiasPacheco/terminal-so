
#ifndef PILA_H
#define PILA_H
    
    struct elemento {
        char ruta[100];
        struct elemento *next;
    };

    /*
    * Estructura para representar la pila.
    */
    struct pila {
        struct elemento *frente;
        int tamano;
    };

    int crear(struct pila *);
    int push(struct pila *, struct elemento);
    int pop(struct pila *, struct elemento *);
    int estaVacia(struct pila);
    void impPila(struct pila *p);

#endif
