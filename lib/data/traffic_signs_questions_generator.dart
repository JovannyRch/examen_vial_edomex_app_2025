/// Generador de preguntas sobre señales de tránsito
/// Basado en el archivo info.html
///
/// Este archivo contiene las preguntas generadas automáticamente
/// que muestran una imagen de señal y preguntan qué tipo es.
library;

import 'package:examen_vial_edomex_app_2025/models/option.dart';

/// Lista de señales de tránsito extraídas de info.html
/// Formato: ¿Qué señal es esta? [Muestra imagen]
/// Respuesta: [Nombre de la señal]

final List<Question> trafficSignsQuestions = [
  // ═══════════════════════════════════════════════════════════════════════════
  // SEÑALES PREVENTIVAS (Amarillas con negro)
  // ═══════════════════════════════════════════════════════════════════════════
  Question(
    id: 1001,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Curva-1471556454125.PNG',
    options: [
      Option(id: 1, text: 'Curva'),
      Option(id: 2, text: 'Curva cerrada'),
      Option(id: 3, text: 'Camino sinuoso'),
      Option(id: 4, text: 'Contracurva'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Se utiliza para indicar curvas a la derecha o izquierda que sean de menos de 90 grados.',
  ),

  Question(
    id: 1002,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Curva_cerrada-1471556503017.PNG',
    options: [
      Option(id: 1, text: 'Curva cerrada'),
      Option(id: 2, text: 'Curva'),
      Option(id: 3, text: 'Curva sinuosa'),
      Option(id: 4, text: 'Bifurcación'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Se usa para indicar curvas a la derecha o izquierda con una curvatura mayor a 90 grados.',
  ),

  Question(
    id: 1003,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Camino_sinuoso-1471556522236.PNG',
    options: [
      Option(id: 1, text: 'Camino sinuoso'),
      Option(id: 2, text: 'Curva sinuosa'),
      Option(id: 3, text: 'Contracurva'),
      Option(id: 4, text: 'Curva'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Significa la presencia de dos o más curvas inversas en el camino.',
  ),

  Question(
    id: 1004,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Curva_sinuosa-1471556676359.png',
    options: [
      Option(id: 1, text: 'Curva sinuosa'),
      Option(id: 2, text: 'Camino sinuoso'),
      Option(id: 3, text: 'Curva cerrada'),
      Option(id: 4, text: 'Contracurva'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Esta señal de tránsito se usa para indicar dos vueltas continuas que van en dirección contraria.',
  ),

  Question(
    id: 1005,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Contracurva-1471556596272.PNG',
    options: [
      Option(id: 1, text: 'Contracurva'),
      Option(id: 2, text: 'Curva sinuosa'),
      Option(id: 3, text: 'Camino sinuoso'),
      Option(id: 4, text: 'Curva cerrada'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Este señalamiento indica la presencia de dos curvas continuas en donde la primera de ellas es cerrada.',
  ),

  Question(
    id: 1006,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Cruce-1471556798974.PNG',
    options: [
      Option(id: 1, text: 'Cruce'),
      Option(id: 2, text: 'Entronque'),
      Option(id: 3, text: 'Bifurcación'),
      Option(id: 4, text: 'Glorieta'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Advierte sobre el cruce de dos caminos. La línea más ancha señalará el camino principal mientras las más angosta es el camino secundario.',
  ),

  Question(
    id: 1007,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Entronque-1471556812425.PNG',
    options: [
      Option(id: 1, text: 'Entronque'),
      Option(id: 2, text: 'Cruce'),
      Option(id: 3, text: 'Bifurcación'),
      Option(id: 4, text: 'Incorporación de tránsito'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Esta señal indica la presencia de una calle que se empalma con la principal. La línea gruesa muestra el camino principal y la angosta el camino secundario en donde los autos deben ceder el paso.',
  ),

  Question(
    id: 1008,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Bifurcaci_n-1471556825167.png',
    options: [
      Option(id: 1, text: 'Bifurcación'),
      Option(id: 2, text: 'Entronque'),
      Option(id: 3, text: 'Bifurcación en Y'),
      Option(id: 4, text: 'Salida'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Advierte de la división del camino. La señal puede ser a la izquierda o a la derecha.',
  ),

  Question(
    id: 1009,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Entronque_delta-1471556836067.png',
    options: [
      Option(id: 1, text: 'Entronque delta'),
      Option(id: 2, text: 'Bifurcación en Y'),
      Option(id: 3, text: 'Glorieta'),
      Option(id: 4, text: 'Cruce'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Se utiliza para señalar una intersección de tres caminos. El camino principal será la línea más ancha, mientras los secundarios con una línea más angosta.',
  ),

  Question(
    id: 1010,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Entronque_en_Y-1471556978920.png',
    options: [
      Option(id: 1, text: 'Bifurcación en Y'),
      Option(id: 2, text: 'Entronque delta'),
      Option(id: 3, text: 'Bifurcación'),
      Option(id: 4, text: 'Cruce'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Esta señal de tránsito advierte sobre la bifurcación del camino. El camino principal será la línea más gruesa.',
  ),

  Question(
    id: 1011,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Glorieta-1471556991993.png',
    options: [
      Option(id: 1, text: 'Glorieta'),
      Option(id: 2, text: 'Cruce'),
      Option(id: 3, text: 'Entronque delta'),
      Option(id: 4, text: 'Doble circulación'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Advierte sobre la presencia de una glorieta en la que se encuentran al menos dos caminos.',
  ),

  Question(
    id: 1012,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Incorporaci_n_de_tr_nsito-1471557002153.png',
    options: [
      Option(id: 1, text: 'Incorporación de tránsito'),
      Option(id: 2, text: 'Entronque'),
      Option(id: 3, text: 'Salida'),
      Option(id: 4, text: 'Doble circulación'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Este tipo de señalamiento avisa sobre la incorporación de tránsito que va en la misma dirección. La incorporación será por el lado que marque la línea más delgada.',
  ),

  Question(
    id: 1013,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Doble_circulaci_n-1471557012119.png',
    options: [
      Option(id: 1, text: 'Doble circulación'),
      Option(id: 2, text: 'Incorporación de tránsito'),
      Option(id: 3, text: 'Camino dividido'),
      Option(id: 4, text: 'Reducción del camino'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'El señalamiento se utiliza para marcar el cambio de circulación de un sólo sentido a circulación en doble sentido.',
  ),

  Question(
    id: 1014,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Salida-1471557031238.png',
    options: [
      Option(id: 1, text: 'Salida'),
      Option(id: 2, text: 'Incorporación de tránsito'),
      Option(id: 3, text: 'Bifurcación'),
      Option(id: 4, text: 'Entronque'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Indica la salida de un camino principal. La línea delgada indicará si la salida es por la izquierda o por la derecha.',
  ),

  Question(
    id: 1015,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Reducci_n_del_camino-1471557045160.png',
    options: [
      Option(id: 1, text: 'Reducción del camino'),
      Option(id: 2, text: 'Reducción del camino lateral'),
      Option(id: 3, text: 'Límite de anchura'),
      Option(id: 4, text: 'Termina pavimento'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Advierte sobre la reducción de la anchura del camino. De forma inversa indica la ampliación del camino.',
  ),

  Question(
    id: 1016,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Reducci_n_del_camino_lateral-1471557059889.png',
    options: [
      Option(id: 1, text: 'Reducción del camino lateral'),
      Option(id: 2, text: 'Reducción del camino'),
      Option(id: 3, text: 'Salida'),
      Option(id: 4, text: 'Incorporación de tránsito'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Señala la reducción del camino por alguno de los costados. El señalamiento indicará si la reducción es por la izquierda o por la derecha.',
  ),

  Question(
    id: 1017,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Puente_levadizo-1471557071878.png',
    options: [
      Option(id: 1, text: 'Puente levadizo'),
      Option(id: 2, text: 'Superficie derrapante'),
      Option(id: 3, text: 'Pendiente peligrosa'),
      Option(id: 4, text: 'Trabajadores en el camino'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Indica la presencia de un puente levadizo en el camino. Un puente levadizo puede desplazarse de forma horizontal para permitir el paso de embarcaciones.',
  ),

  Question(
    id: 1018,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Trabajadores_en_el_camino-1471557081415.PNG',
    options: [
      Option(id: 1, text: 'Trabajadores en el camino'),
      Option(id: 2, text: 'Zona escolar'),
      Option(id: 3, text: 'Paso peatonal'),
      Option(id: 4, text: 'Maquinaria agrícola'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'El señalamiento indica la presencia de trabajadores en el camino.',
  ),

  Question(
    id: 1019,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/L_mite_de_anchura-1471557093158.png',
    options: [
      Option(id: 1, text: 'Límite de anchura'),
      Option(id: 2, text: 'Límite de altura'),
      Option(id: 3, text: 'Reducción del camino'),
      Option(id: 4, text: 'Puente levadizo'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'La señal se utiliza para indicar un camino estrecho que no permite la circulación de dos vehículos de forma simultánea. Suele ir acompañada de un tablero adicional que indica la anchura exacta del camino.',
  ),

  Question(
    id: 1020,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/L_mite_de_altura-1471557112024.png',
    options: [
      Option(id: 1, text: 'Límite de altura'),
      Option(id: 2, text: 'Límite de anchura'),
      Option(id: 3, text: 'Puente levadizo'),
      Option(id: 4, text: 'Túnel'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Indica el límite de espacio de forma vertical cuando es menor a 4.30 metros. Normalmente un segundo tablero indica la altura máxima.',
  ),

  Question(
    id: 1021,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Arrollo-1471557120848.png',
    options: [
      Option(id: 1, text: 'Corriente de agua'),
      Option(id: 2, text: 'Termina pavimento'),
      Option(id: 3, text: 'Superficie derrapante'),
      Option(id: 4, text: 'Zona de derrumbes'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Advierte sobre una corriente de agua baja por la cual se puede circular.',
  ),

  Question(
    id: 1022,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Termina_pavimento-1471557127931.png',
    options: [
      Option(id: 1, text: 'Termina pavimento'),
      Option(id: 2, text: 'Superficie derrapante'),
      Option(id: 3, text: 'Grava suelta'),
      Option(id: 4, text: 'Corriente de agua'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Señala el fin del pavimento y la presencia de un camino de terracería.',
  ),

  Question(
    id: 1023,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Superficie_derrapante-1471557160574.png',
    options: [
      Option(id: 1, text: 'Superficie derrapante'),
      Option(id: 2, text: 'Termina pavimento'),
      Option(id: 3, text: 'Grava suelta'),
      Option(id: 4, text: 'Pendiente peligrosa'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Esta señal de tránsito indicará un tramo de pavimento resbaladizo. Es una señal temporal.',
  ),

  Question(
    id: 1024,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Pendiente_peligrosa-1471557169853.png',
    options: [
      Option(id: 1, text: 'Pendiente peligrosa'),
      Option(id: 2, text: 'Superficie derrapante'),
      Option(id: 3, text: 'Zona de derrumbes'),
      Option(id: 4, text: 'Curva cerrada'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Advierte sobre un camino en descenso en el cual habrá que frenar constantemente.',
  ),

  Question(
    id: 1025,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Zona_de_derrumbes-1471557182861.png',
    options: [
      Option(id: 1, text: 'Zona de derrumbes'),
      Option(id: 2, text: 'Pendiente peligrosa'),
      Option(id: 3, text: 'Trabajadores en el camino'),
      Option(id: 4, text: 'Grava suelta'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation: 'Advierte sobre una zona en la cual pueden ocurrir derrumbes.',
  ),

  Question(
    id: 1026,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Alto_pr_ximo-1471557189858.png',
    options: [
      Option(id: 1, text: 'Alto próximo'),
      Option(id: 2, text: 'Semáforo'),
      Option(id: 3, text: 'Paso peatonal'),
      Option(id: 4, text: 'Zona escolar'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Es una de las señales de tránsito preventivas menos conocidas pero muy usual. Advierte sobre una señal de alto cercana.',
  ),

  Question(
    id: 1027,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Paso_peatonal-1471557197650.png',
    options: [
      Option(id: 1, text: 'Paso peatonal'),
      Option(id: 2, text: 'Zona escolar'),
      Option(id: 3, text: 'Alto próximo'),
      Option(id: 4, text: 'Ciclistas'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Indica un camino con constante paso peatonal o un cruce peatonal en específico.',
  ),

  Question(
    id: 1028,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Zona_escolar-1471557208809.png',
    options: [
      Option(id: 1, text: 'Zona escolar'),
      Option(id: 2, text: 'Paso peatonal'),
      Option(id: 3, text: 'Trabajadores en el camino'),
      Option(id: 4, text: 'Semáforo'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Advierte sobre una zona de escuelas cercana para que el conductor reduzca su velocidad.',
  ),

  Question(
    id: 1029,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Ganado-1471557217651.png',
    options: [
      Option(id: 1, text: 'Ganado'),
      Option(id: 2, text: 'Maquinaria agrícola'),
      Option(id: 3, text: 'Ciclistas'),
      Option(id: 4, text: 'Paso peatonal'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation: 'Indica la posibilidad de encontrar ganado en el camino.',
  ),

  Question(
    id: 1030,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Cruce_de_ferrocarril-1471557226492.png',
    options: [
      Option(id: 1, text: 'Cruce de ferrocarril'),
      Option(id: 2, text: 'Trabajadores en el camino'),
      Option(id: 3, text: 'Semáforo'),
      Option(id: 4, text: 'Maquinaria agrícola'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation: 'Señala el cruce con vías de tren al mismo nivel del camino.',
  ),

  Question(
    id: 1031,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Maquinaria_ag_cola-1471557244786.png',
    options: [
      Option(id: 1, text: 'Maquinaria agrícola'),
      Option(id: 2, text: 'Ganado'),
      Option(id: 3, text: 'Trabajadores en el camino'),
      Option(id: 4, text: 'Ciclistas'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Se utiliza para marcar una zona de tránsito de maquinaria agrícola o un cruce específico de este tipo de vehículos.',
  ),

  Question(
    id: 1032,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Sem_foro-1471557253226.png',
    options: [
      Option(id: 1, text: 'Semáforo'),
      Option(id: 2, text: 'Alto próximo'),
      Option(id: 3, text: 'Cruce'),
      Option(id: 4, text: 'Trabajadores en el camino'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Este señalamiento advierte sobre la presencia de un semáforo próximo, normalmente en cruces o en zonas donde no se espera hallarlos.',
  ),

  Question(
    id: 1033,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Camino_dividido-1471557264952.png',
    options: [
      Option(id: 1, text: 'Camino dividido'),
      Option(id: 2, text: 'Doble circulación'),
      Option(id: 3, text: 'Bifurcación'),
      Option(id: 4, text: 'Reducción del camino'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Esta señal de tránsito advierte sobre la división del camino en dos.',
  ),

  Question(
    id: 1034,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Ciclistas-1471557278348.png',
    options: [
      Option(id: 1, text: 'Ciclistas'),
      Option(id: 2, text: 'Maquinaria agrícola'),
      Option(id: 3, text: 'Paso peatonal'),
      Option(id: 4, text: 'Ganado'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Advierte sobre un camino frecuentado por ciclistas o un cruce específico de estos vehículos.',
  ),

  Question(
    id: 1035,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Grava_suelta-1471557286486.png',
    options: [
      Option(id: 1, text: 'Grava suelta'),
      Option(id: 2, text: 'Superficie derrapante'),
      Option(id: 3, text: 'Termina pavimento'),
      Option(id: 4, text: 'Zona de derrumbes'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Advierte sobre un tramo en donde hay tierra o grava en el camino.',
  ),

  // ═══════════════════════════════════════════════════════════════════════════
  // SEÑALES RESTRICTIVAS (Rojas y blancas)
  // ═══════════════════════════════════════════════════════════════════════════
  Question(
    id: 1036,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Alto-1471558292409.png',
    options: [
      Option(id: 1, text: 'Alto'),
      Option(id: 2, text: 'Ceda el paso'),
      Option(id: 3, text: 'Inspección'),
      Option(id: 4, text: 'No circular'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Es una de las señales de tránsito más conocidas. Se utiliza principalmente en entronques con gran afluencia, cruces urbanos con riesgo de accidentes, y en cruces con líneas férreas.',
  ),

  Question(
    id: 1037,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Ceda_el_paso-1471558328731.png',
    options: [
      Option(id: 1, text: 'Ceda el paso'),
      Option(id: 2, text: 'Alto'),
      Option(id: 3, text: 'Inspección'),
      Option(id: 4, text: 'Reducción del camino'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Esta señal es una advertencia para los conductores para reducir su velocidad y ceder el paso siempre que sea necesario. Es ocupada en zonas de vasto tránsito de peatones y vehículos o en entronques con avenidas principales.',
  ),

  Question(
    id: 1038,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Inspecci_n-1471558342771.png',
    options: [
      Option(id: 1, text: 'Inspección'),
      Option(id: 2, text: 'Alto'),
      Option(id: 3, text: 'Ceda el paso'),
      Option(id: 4, text: 'No circular'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Indica la presencia de autoridades de tránsito. Normalmente se usa para advertir sobre retenes de revisión.',
  ),

  Question(
    id: 1039,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Velocidad_m_xima-1471558349524.png',
    options: [
      Option(id: 1, text: 'Velocidad máxima'),
      Option(id: 2, text: 'No rebasar'),
      Option(id: 3, text: 'Alto'),
      Option(id: 4, text: 'Inspección'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Este tipo de señal de tránsito indica el límite de velocidad máximo para circular.',
  ),

  Question(
    id: 1040,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Vuelta_a_la_derecha_continua-1471558359452.png',
    options: [
      Option(id: 1, text: 'Vuelta continua'),
      Option(id: 2, text: 'Vuelta prohibida'),
      Option(id: 3, text: 'Circulación'),
      Option(id: 4, text: 'Retorno prohibido'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Indica la posibilidad de dar la vuelta. Su uso es común en cruces. La señal puede marcar vuelta a la izquierda y derecha.',
  ),

  Question(
    id: 1041,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Circulaci_n-1471558367898.png',
    options: [
      Option(id: 1, text: 'Circulación'),
      Option(id: 2, text: 'Vuelta continua'),
      Option(id: 3, text: 'Doble circulación'),
      Option(id: 4, text: 'Conservar la derecha'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Muestra el sentido de la circulación. Se usa en entradas de calles a fin de evitar la invasión de carriles con circulación única.',
  ),

  Question(
    id: 1042,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Prohibido_rebasar-1471558378203.png',
    options: [
      Option(id: 1, text: 'No rebasar'),
      Option(id: 2, text: 'Velocidad máxima'),
      Option(id: 3, text: 'Conservar la derecha'),
      Option(id: 4, text: 'Alto'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'La señal de tránsito prohíbe a los conductores rebasar en la zona.',
  ),

  Question(
    id: 1043,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Conservar_la__derecha-1471558387666.png',
    options: [
      Option(id: 1, text: 'Conservar la derecha'),
      Option(id: 2, text: 'Circulación'),
      Option(id: 3, text: 'No rebasar'),
      Option(id: 4, text: 'Vuelta continua'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Insta a los conductores de camiones a conservar su derecha a fin de dejar el carril izquierdo libre para los vehículos ligeros.',
  ),

  Question(
    id: 1044,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Doble_circulaci_n-1471558398117.png',
    options: [
      Option(id: 1, text: 'Doble circulación'),
      Option(id: 2, text: 'Circulación'),
      Option(id: 3, text: 'Camino dividido'),
      Option(id: 4, text: 'Conservar la derecha'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Se utiliza para indicar cuando la circulación cambia de un sólo sentido a ambos. El señalamiento se coloca al inicio de la calle.',
  ),

  Question(
    id: 1045,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Altura_restringida-1471558421501.png',
    options: [
      Option(id: 1, text: 'Altura restringida'),
      Option(id: 2, text: 'Anchura restringida'),
      Option(id: 3, text: 'Peso restringido'),
      Option(id: 4, text: 'Límite de altura'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Este tipo de señal de tránsito se utiliza para indicar el límite de altura de vehículos para circular en un camino. Es ocupada en la entrada de puentes.',
  ),

  Question(
    id: 1046,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Anchura_restringida-1471558432598.png',
    options: [
      Option(id: 1, text: 'Anchura restringida'),
      Option(id: 2, text: 'Altura restringida'),
      Option(id: 3, text: 'Peso restringido'),
      Option(id: 4, text: 'Límite de anchura'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'El señalamiento indica el límite de anchura de vehículos para circular en un camino.',
  ),

  Question(
    id: 1047,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Peso_restringido-1471558442641.png',
    options: [
      Option(id: 1, text: 'Peso restringido'),
      Option(id: 2, text: 'Altura restringida'),
      Option(id: 3, text: 'Anchura restringida'),
      Option(id: 4, text: 'Velocidad máxima'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Advierte sobre el peso máximo de los vehículos para circular en un camino.',
  ),

  Question(
    id: 1048,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Usar_el_cintur_n_de_seguridad-1471558451707.png',
    options: [
      Option(id: 1, text: 'Uso obligatorio de cinturón de seguridad'),
      Option(id: 2, text: 'Parada prohibida'),
      Option(id: 3, text: 'No parar'),
      Option(id: 4, text: 'Inspección'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Indica el uso obligatorio del cinturón de seguridad en la zona de todos los ocupantes del vehículo.',
  ),

  Question(
    id: 1049,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Parada_prohibida-1471558465322.png',
    options: [
      Option(id: 1, text: 'Parada prohibida'),
      Option(id: 2, text: 'No parar'),
      Option(id: 3, text: 'Prohibido estacionarse'),
      Option(id: 4, text: 'Alto'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Se utiliza para indicar a conductores de transporte público la prohibición de subir o bajar pasaje en el lugar.',
  ),

  Question(
    id: 1050,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/No_parar-1471558473622.png',
    options: [
      Option(id: 1, text: 'No parar'),
      Option(id: 2, text: 'Parada prohibida'),
      Option(id: 3, text: 'Prohibido estacionarse'),
      Option(id: 4, text: 'Alto'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'La señal prohíbe a los vehículos detenerse. Se utiliza en avenidas de circulación rápida, así como en las entradas y salidas de emergencia.',
  ),

  Question(
    id: 1051,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Estacionamiento-1471558483679.png',
    options: [
      Option(id: 1, text: 'Estacionamiento'),
      Option(id: 2, text: 'Prohibido estacionarse'),
      Option(id: 3, text: 'No parar'),
      Option(id: 4, text: 'Parada prohibida'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Indica que es posible estacionarse en el lugar. Va acompañada con las limitaciones de tiempo, horarios y días donde se puede estacionar.',
  ),

  Question(
    id: 1052,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Prohibido_estacionarse_-1471558495816.png',
    options: [
      Option(id: 1, text: 'Prohibido estacionarse'),
      Option(id: 2, text: 'Estacionamiento'),
      Option(id: 3, text: 'No parar'),
      Option(id: 4, text: 'Parada prohibida'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation: 'Se utiliza en zonas en donde está prohibido estacionarse.',
  ),

  Question(
    id: 1053,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Vuelta_a_la_derecha_prohibida-1471558503936.png',
    options: [
      Option(id: 1, text: 'Vuelta a la derecha prohibida'),
      Option(id: 2, text: 'Retorno prohibido'),
      Option(id: 3, text: 'Prohibido seguir de frente'),
      Option(id: 4, text: 'Vuelta continua'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Prohíbe la vuelta a la derecha ya sea por circulación contraria o condiciones del camino.',
  ),

  Question(
    id: 1054,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Retorno_prohibido-1471558510689.png',
    options: [
      Option(id: 1, text: 'Retorno prohibido'),
      Option(id: 2, text: 'Vuelta a la derecha prohibida'),
      Option(id: 3, text: 'Prohibido seguir de frente'),
      Option(id: 4, text: 'No circular'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Indica que se prohíbe el retorno de autos por este cruce. Puede ser porque representa un peligro extra o causa problemas en el tránsito.',
  ),

  Question(
    id: 1055,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Prohibido_seguir_de_frente-1471558517019.png',
    options: [
      Option(id: 1, text: 'Prohibido seguir de frente'),
      Option(id: 2, text: 'Retorno prohibido'),
      Option(id: 3, text: 'Vuelta a la derecha prohibida'),
      Option(id: 4, text: 'Alto'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'La señal de tránsito indica que se prohíbe seguir circulando de frente.',
  ),

  Question(
    id: 1056,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Prohibido_el_paso_a_motocicletas__veh_culos_pesado_y_bicicletas-1471558524530.png',
    options: [
      Option(
        id: 1,
        text:
            'Prohibido el paso a motocicletas, vehículos pesados y bicicletas',
      ),
      Option(id: 2, text: 'Prohibido el paso a maquinaria agrícola'),
      Option(id: 3, text: 'Prohibido el paso a peatones'),
      Option(id: 4, text: 'No circular'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Indica la prohibición de circular de estos vehículos en una zona. Puede aparecer de forma individual también.',
  ),

  Question(
    id: 1057,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Prohibido_el_paso_a_maquinaria_agr_colas-1471558531269.png',
    options: [
      Option(id: 1, text: 'Prohibido el paso a maquinaria agrícola'),
      Option(
        id: 2,
        text:
            'Prohibido el paso a motocicletas, vehículos pesados y bicicletas',
      ),
      Option(id: 3, text: 'Prohibido el paso a peatones'),
      Option(id: 4, text: 'Maquinaria agrícola'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation: 'Prohíbe la circulación de maquinaria agrícola en una zona.',
  ),

  Question(
    id: 1058,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Prohibido_el_paso_a_peatones-1471558543553.png',
    options: [
      Option(id: 1, text: 'Prohibido el paso a peatones'),
      Option(id: 2, text: 'Paso peatonal'),
      Option(id: 3, text: 'Zona escolar'),
      Option(id: 4, text: 'Prohibido usar el claxon'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Se usa en zonas en donde la afluencia de vehículos hace peligroso el cruce de peatones.',
  ),

  Question(
    id: 1059,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Prohibido_usar_el_claxon-1471558558018.png',
    options: [
      Option(id: 1, text: 'Prohibido usar el claxon'),
      Option(id: 2, text: 'Prohibido el paso a peatones'),
      Option(id: 3, text: 'Zona escolar'),
      Option(id: 4, text: 'No parar'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation: 'Indica que está prohibido usar el claxon en una zona.',
  ),

  // ═══════════════════════════════════════════════════════════════════════════
  // SEÑALES INFORMATIVAS - SERVICIOS Y TURÍSTICAS
  // ═══════════════════════════════════════════════════════════════════════════
  Question(
    id: 1060,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Primeros_auxilios-1471559312063.jpg',
    options: [
      Option(id: 1, text: 'Primeros auxilios'),
      Option(id: 2, text: 'Oficinas de información'),
      Option(id: 3, text: 'Taller mecánico'),
      Option(id: 4, text: 'Baños'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Señal de servicio que indica la ubicación de un punto de primeros auxilios.',
  ),

  Question(
    id: 1061,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Oficinas_de_informaci_n-1471559322886.png',
    options: [
      Option(id: 1, text: 'Oficinas de información'),
      Option(id: 2, text: 'Primeros auxilios'),
      Option(id: 3, text: 'Caseta telefónica'),
      Option(id: 4, text: 'Oficina de correos'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Indica la ubicación de oficinas de información turística o de servicios.',
  ),

  Question(
    id: 1062,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Caseta_telef_nica-1471559329193.png',
    options: [
      Option(id: 1, text: 'Caseta telefónica'),
      Option(id: 2, text: 'Oficinas de información'),
      Option(id: 3, text: 'Oficina de correos'),
      Option(id: 4, text: 'Primeros auxilios'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation: 'Indica la ubicación de una caseta telefónica.',
  ),

  Question(
    id: 1063,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Estaci_n_de_servicio-1471559335319.png',
    options: [
      Option(id: 1, text: 'Estación de servicio'),
      Option(id: 2, text: 'Taller mecánico'),
      Option(id: 3, text: 'Restaurantes'),
      Option(id: 4, text: 'Hospedaje'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Indica la ubicación de una gasolinera o estación de servicio.',
  ),

  Question(
    id: 1064,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Oficina_de_correos-1471559349513.jpg',
    options: [
      Option(id: 1, text: 'Oficina de correos'),
      Option(id: 2, text: 'Oficinas de información'),
      Option(id: 3, text: 'Caseta telefónica'),
      Option(id: 4, text: 'Primeros auxilios'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation: 'Indica la ubicación de una oficina de correos.',
  ),

  Question(
    id: 1065,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Taller_mec_nico-1471559386205.png',
    options: [
      Option(id: 1, text: 'Taller mecánico'),
      Option(id: 2, text: 'Estación de servicio'),
      Option(id: 3, text: 'Baños'),
      Option(id: 4, text: 'Restaurantes'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation: 'Indica la ubicación de un taller mecánico.',
  ),

  Question(
    id: 1066,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Ba_os-1471559399182.png',
    options: [
      Option(id: 1, text: 'Baños'),
      Option(id: 2, text: 'Restaurantes'),
      Option(id: 3, text: 'Hospedaje'),
      Option(id: 4, text: 'Taller mecánico'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation: 'Indica la ubicación de baños o sanitarios públicos.',
  ),

  Question(
    id: 1067,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Restaurantes-1471559417140.png',
    options: [
      Option(id: 1, text: 'Restaurantes'),
      Option(id: 2, text: 'Baños'),
      Option(id: 3, text: 'Hospedaje'),
      Option(id: 4, text: 'Comedor al aire libre'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation: 'Indica la ubicación de restaurantes o servicios de comida.',
  ),

  Question(
    id: 1068,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Hospedaje-1471559423744.png',
    options: [
      Option(id: 1, text: 'Hospedaje'),
      Option(id: 2, text: 'Restaurantes'),
      Option(id: 3, text: 'Baños'),
      Option(id: 4, text: 'Zona turística'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation: 'Indica la ubicación de hoteles o servicios de hospedaje.',
  ),

  Question(
    id: 1069,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Estaci_n_de_ferrocarriles-1471559430644.png',
    options: [
      Option(id: 1, text: 'Estación de ferrocarriles'),
      Option(id: 2, text: 'Cruce de ferrocarril'),
      Option(id: 3, text: 'Fin de autopista'),
      Option(id: 4, text: 'Hospedaje'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation: 'Indica la ubicación de una estación de tren.',
  ),

  Question(
    id: 1070,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Fin_de_autopista-1471559439536.png',
    options: [
      Option(id: 1, text: 'Fin de autopista'),
      Option(id: 2, text: 'Estación de ferrocarriles'),
      Option(id: 3, text: 'Termina pavimento'),
      Option(id: 4, text: 'Reducción del camino'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation: 'Indica el final de una autopista o vía rápida.',
  ),

  Question(
    id: 1071,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Artesan_as-1471559447213.png',
    options: [
      Option(id: 1, text: 'Artesanías'),
      Option(id: 2, text: 'Zona turística'),
      Option(id: 3, text: 'Sitio histórico'),
      Option(id: 4, text: 'Restaurantes'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation: 'Indica la ubicación de venta de artesanías.',
  ),

  Question(
    id: 1072,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Zona_tur_stica-1471559464892.png',
    options: [
      Option(id: 1, text: 'Zona turística'),
      Option(id: 2, text: 'Artesanías'),
      Option(id: 3, text: 'Sitio histórico'),
      Option(id: 4, text: 'Parque nacional'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation: 'Indica una zona de atractivo turístico.',
  ),

  Question(
    id: 1073,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Comedor_al_aire_libre-1471559474073.png',
    options: [
      Option(id: 1, text: 'Comedor al aire libre'),
      Option(id: 2, text: 'Restaurantes'),
      Option(id: 3, text: 'Zona de acampar'),
      Option(id: 4, text: 'Zona turística'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Indica la ubicación de un área de comedor al aire libre o picnic.',
  ),

  Question(
    id: 1074,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Basura-1471559480143.png',
    options: [
      Option(id: 1, text: 'Botes de basura'),
      Option(id: 2, text: 'Baños'),
      Option(id: 3, text: 'Comedor al aire libre'),
      Option(id: 4, text: 'Zona de acampar'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Indica la ubicación de botes de basura o depósito de residuos.',
  ),

  Question(
    id: 1075,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Volc_n-1471559495923.png',
    options: [
      Option(id: 1, text: 'Volcán'),
      Option(id: 2, text: 'Parque nacional'),
      Option(id: 3, text: 'Zona turística'),
      Option(id: 4, text: 'Alpinismo'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation: 'Indica un atractivo turístico: volcán.',
  ),

  Question(
    id: 1076,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Parque_nacional-1471559501702.png',
    options: [
      Option(id: 1, text: 'Parque nacional'),
      Option(id: 2, text: 'Zona turística'),
      Option(id: 3, text: 'Zona de acampar'),
      Option(id: 4, text: 'Excursión'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation: 'Indica la ubicación de un parque nacional.',
  ),

  Question(
    id: 1077,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Zona_de_acampar-1471559512042.png',
    options: [
      Option(id: 1, text: 'Zona de acampar'),
      Option(id: 2, text: 'Parque nacional'),
      Option(id: 3, text: 'Comedor al aire libre'),
      Option(id: 4, text: 'Excursión'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation: 'Indica una zona designada para acampar.',
  ),

  Question(
    id: 1078,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Juegos_para_ni_o-1471559517967.PNG',
    options: [
      Option(id: 1, text: 'Juegos infantiles'),
      Option(id: 2, text: 'Zona escolar'),
      Option(id: 3, text: 'Parque nacional'),
      Option(id: 4, text: 'Zona de acampar'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation:
        'Indica la ubicación de juegos infantiles o parque para niños.',
  ),

  Question(
    id: 1079,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Pesca-1471559525720.png',
    options: [
      Option(id: 1, text: 'Pesca'),
      Option(id: 2, text: 'Natación'),
      Option(id: 3, text: 'Buceo'),
      Option(id: 4, text: 'Playa'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation: 'Indica una zona permitida para pesca.',
  ),

  Question(
    id: 1080,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Escursi_n-1471559532590.png',
    options: [
      Option(id: 1, text: 'Excursión'),
      Option(id: 2, text: 'Alpinismo'),
      Option(id: 3, text: 'Zona de acampar'),
      Option(id: 4, text: 'Parque nacional'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation: 'Indica una zona de excursión o senderismo.',
  ),

  Question(
    id: 1081,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Monumento_religoso-1471559539721.png',
    options: [
      Option(id: 1, text: 'Monumento religioso'),
      Option(id: 2, text: 'Sitio histórico'),
      Option(id: 3, text: 'Zona turística'),
      Option(id: 4, text: 'Artesanías'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation: 'Indica la ubicación de un monumento o sitio religioso.',
  ),

  Question(
    id: 1082,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Sitio_hist_rico-1471559551300.png',
    options: [
      Option(id: 1, text: 'Sitio histórico'),
      Option(id: 2, text: 'Monumento religioso'),
      Option(id: 3, text: 'Zona turística'),
      Option(id: 4, text: 'Artesanías'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation: 'Indica la ubicación de un sitio de interés histórico.',
  ),

  Question(
    id: 1083,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Cascada-1471559575562.png',
    options: [
      Option(id: 1, text: 'Cascada'),
      Option(id: 2, text: 'Natación'),
      Option(id: 3, text: 'Zona turística'),
      Option(id: 4, text: 'Parque nacional'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation: 'Indica un atractivo turístico: cascada.',
  ),

  Question(
    id: 1084,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Buceo-1471559583179.png',
    options: [
      Option(id: 1, text: 'Buceo'),
      Option(id: 2, text: 'Natación'),
      Option(id: 3, text: 'Pesca'),
      Option(id: 4, text: 'Playa'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation: 'Indica una zona permitida para buceo.',
  ),

  Question(
    id: 1085,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Playa-1471559590957.png',
    options: [
      Option(id: 1, text: 'Playa'),
      Option(id: 2, text: 'Natación'),
      Option(id: 3, text: 'Buceo'),
      Option(id: 4, text: 'Cascada'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation: 'Indica la ubicación de una playa.',
  ),

  Question(
    id: 1086,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Nataci_n-1471559598692.png',
    options: [
      Option(id: 1, text: 'Natación'),
      Option(id: 2, text: 'Buceo'),
      Option(id: 3, text: 'Playa'),
      Option(id: 4, text: 'Pesca'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation: 'Indica una zona permitida para natación.',
  ),

  Question(
    id: 1087,
    text: '¿Qué señal de tránsito es esta?',
    imagePath:
        'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Alpinismos-1471559608529.png',
    options: [
      Option(id: 1, text: 'Alpinismo'),
      Option(id: 2, text: 'Excursión'),
      Option(id: 3, text: 'Volcán'),
      Option(id: 4, text: 'Parque nacional'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation: 'Indica una zona de alpinismo o escalada.',
  ),
];
