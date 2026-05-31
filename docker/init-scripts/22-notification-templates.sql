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
 TRUE),

('CANCELLATION_EMAIL', 'Cancelación de evento', 'EMAIL',
 'Evento cancelado: {{evento}}',
 'Hola {{nombre}},

El evento "{{evento}}" del {{fecha}} ha sido cancelado.

{{motivo}}

Si realizaste una compra por ${{total}}, el reembolso será procesado automáticamente.

Saludos,
Equipo VivaEventos',
 ARRAY['nombre', 'evento', 'fecha', 'motivo', 'total'],
 TRUE),

('PROMOTION_EMAIL', 'Oferta especial para ti', 'EMAIL',
 'Oferta especial: {{descuento}} en {{evento}}',
 'Hola {{nombre}},

Gracias por tu compra en "{{evento}}". Como agradecimiento, te ofrecemos un {{descuento}} en tu próxima compra.

Usa el código: {{codigo_promocion}}
Válido hasta: {{fecha_expiracion}}

¡No dejes pasar esta oportunidad!

Saludos,
Equipo VivaEventos',
 ARRAY['nombre', 'evento', 'descuento', 'codigo_promocion', 'fecha_expiracion'],
 TRUE)
ON CONFLICT (code) DO NOTHING;
