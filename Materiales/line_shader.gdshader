shader_type canvas_item;

uniform float health_level; // Nivel de vida entre 0 y 1
uniform float max_health; // Máximo nivel de vida

void fragment() {
    // Calcula el porcentaje de vida restante
    float health_percentage = health_level / max_health;

    // Color rojo para la parte de vida perdida
    vec4 lost_health_color = vec4(1.0, 0.0, 0.0, 1.0);

    // Color verde para la parte de vida restante
    vec4 remaining_health_color = vec4(0.0, 1.0, 0.0, 1.0);

    // Determina el color de la línea de vida dependiendo del porcentaje de vida restante
    vec4 final_color = mix(lost_health_color, remaining_health_color, health_percentage);

    // Asigna el color al fragmento
    COLOR = final_color;
}
