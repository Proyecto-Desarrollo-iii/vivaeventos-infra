-- Seed notification templates
\c vivaeventos_notifications;

INSERT INTO notification_templates (code, name, channel, subject, body_template, variables, is_active)
VALUES
('REMINDER_EMAIL', 'Recordatorio de evento', 'EMAIL',
 'Recordatorio: {{evento}} - {{fecha}}',
 'Hola {{nombre}},

Te recordamos que el evento "{{evento}}" se llevará a cabo el {{fecha}} a las {{hora}} en {{lugar}}.

¡No olvides tu código QR! {{codigo_qr}}

Saludos,
Equipo VivaEventos',
 ARRAY['nombre', 'evento', 'fecha', 'hora', 'lugar', 'codigo_qr'],
 TRUE),

('CHANGE_EMAIL', 'Cambios en evento', 'EMAIL',
 'Cambios en {{evento}}',
 'Hola {{nombre}},

El evento "{{evento}}" ha sido modificado.

{{detalle_cambio}}

Nueva fecha: {{nueva_fecha}}
Nuevo lugar: {{nuevo_lugar}}

Saludos,
Equipo VivaEventos',
 ARRAY['nombre', 'evento', 'detalle_cambio', 'nueva_fecha', 'nuevo_lugar'],
 TRUE)
ON CONFLICT (code) DO NOTHING;
