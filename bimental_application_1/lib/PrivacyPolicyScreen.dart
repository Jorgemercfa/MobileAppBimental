import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A119B),
        automaticallyImplyLeading: false,
        title: Text(
          'Política de Privacidad',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildSectionTitle('1. Introducción'),
            _buildSectionText(
                'Esta Política de Privacidad describe cómo nuestra aplicación móvil recopila, usa, almacena, protege y comparte la información de los usuarios en relación con la evaluación aproximada de los niveles de depresión, ansiedad y estrés basada en el cuestionario DASS-21. El uso de la Aplicación está sujeto a la aceptación de esta política.'),
            _buildSectionTitle('2. Información Recopilada'),
            _buildSectionText(
                'Datos personales para la cuenta: Para crear una cuenta y utilizar la evaluación, se solicitará su nombre y correo electrónico. El proporcionar esta información es necesario para el funcionamiento básico de la aplicación.'),
            _buildSectionText(
                'Datos personales como el nombre y correo electrónico serán procesados para crear una cuenta y gestionar mi evaluación.'),
            _buildSectionText(
                'Respuestas al cuestionario DASS-21: Datos ingresados por el usuario durante la evaluación.'),
            _buildSectionText(
                'Resultados de la evaluación: Nivel de depresión, ansiedad y estrés según el procesamiento del modelo de Machine Learning. Estos resultados son estrictamente aproximados y no constituyen bajo ningún concepto un diagnóstico médico profesional.'),
            _buildSectionText(
                'Datos de actividad: Registros de uso de la Aplicación con fines de mantenimiento y mejora técnica.'),
            _buildSectionTitle('3. Decisiones Automatizadas'),
            _buildSectionText(
                'Nuestra aplicación utiliza un modelo de Machine Learning entrenado con un conjunto de datos sintéticos diseñados para reconocer patrones relacionados con la escala DASS-21. A partir de frases de los usuarios, el sistema transforma el texto en información numérica y lo analiza para identificar niveles de depresión, ansiedad o estrés, ofreciendo resultados que van desde leve hasta extremadamente severo.'),
            _buildSectionText(
                'Si un usuario responde con frases como "me siento constantemente agotado y sin ganas de hacer nada", el sistema puede interpretar esta información como un indicador de depresión en nivel severo, ya que refleja un estado persistente de falta de energía y motivación que interfiere de manera significativa en su vida cotidiana.'),
            _buildSectionText(
                'Asimismo, los factores o criterios empleados por el sistema para relacionar las respuestas del usuario con la existencia de cuadros psicológicos son los siguientes:'),
            _buildSectionText(
                'Depresión: presencia de sentimientos de tristeza, falta de interés, agotamiento, sensación de inutilidad o desesperanza.'),
            _buildSectionText(
                'Ansiedad: nerviosismo frecuente, dificultad para relajarse, tensión muscular, preocupación excesiva o miedo anticipado.'),
            _buildSectionText(
                'Estrés: dificultad para concentrarse, irritabilidad, sensación de sobrecarga, impaciencia o problemas para descansar adecuadamente.'),
            _buildSectionText(
                'Estos resultados se generan mediante cálculos automáticos del modelo y se complementan con procesos de validación clínica y técnica, garantizando que la información presentada sea confiable y útil para fines de orientación en salud mental.'),
            _buildSectionTitle('4. Propósitos del Uso de la Información'),
            _buildSectionText(
                'Los datos recopilados serán utilizados con los siguientes propósitos esenciales y no esenciales:'),
            _buildSectionText(
                'Finalidad Esencial (Base legal: Ejecución del contrato):'),
            _buildSectionText(
                'Procesar las respuestas al DASS-21 suministradas y generar resultados de triaje aproximados.'),
            _buildSectionText(
                'Finalidades No Esenciales (Base legal: Consentimiento explícito):'),
            _buildSectionText(
                'Contacto proactivo: Permitir que el administrador de la Aplicación pueda contactarlo únicamente si sus resultados en cualquiera de las escalas (depresión, ansiedad o estrés) alcanzan un nivel Severo o Extremadamente Severo, para ofrecerle información sobre opciones de apoyo y derivación a profesionales. Esta acción requiere su consentimiento expreso por separado:'),
            _buildSectionText(
                'Sí, acepto que pueda ser contactado por un administrador en caso de que mis resultados sean Severos o Extremadamente Severos.'),
            _buildSectionText(
                'Recomendaciones: Proporcionarle recomendaciones de contacto o recursos de salud mental en caso de resultados elevados. Esta acción requiere su consentimiento expreso por separado:'),
            _buildSectionText(
                'Sí, acepto recibir recomendaciones o información de contacto basadas en mis resultados.'),
            _buildSectionText(
                'Finalidades Operativas (Base legal: Interés legítimo):'),
            _buildSectionText(
                'Almacenar los resultados de forma anonimizada para análisis estadísticos agregados.'),
            _buildSectionText(
                'Mejorar la funcionalidad, seguridad y experiencia de usuario de la Aplicación.'),
            _buildSectionText(
                'Realizar labores de mantenimiento y soporte técnico.'),
            _buildSectionTitle('5. Compartición y Transferencia de Datos'),
            _buildSectionText(
                'La información recopilada no será compartida con terceros, salvo en los siguientes casos:'),
            _buildSectionText(
                'Con su consentimiento explícito: Para las finalidades específicas no esenciales detalladas en el punto 3, para las cuales usted ha marcado las casillas de aceptación correspondientes.'),
            _buildSectionText(
                'Transferencias a Proveedores de Servicio (Encargados del Tratamiento): Sus datos personales podrán ser transferidos a las siguientes empresas, que actúan como nuestros encargados de procesamiento y nos prestan servicios esenciales para el funcionamiento de la Aplicación, bajo estrictos contratos que garantizan la confidencialidad y seguridad de sus datos:'),
            _buildSectionText(
                'Proveedor de Hosting/Cloud (Ej: Amazon Web Services, Google Cloud Platform): Para el almacenamiento seguro y alojamiento de la base de datos y la aplicación. Finalidad: Alojamiento de datos e infraestructura técnica.'),
            _buildSectionText(
                'Proveedor de Servicios de Análisis (Ej: Google Firebase, Google Analytics): Para el análisis de fallos, rendimiento y uso de la aplicación de forma agregada y anónima. Finalidad: Mejora de la calidad y experiencia de usuario.'),
            _buildSectionText(
                'Proveedor de Servicios de Email (Ej: SendGrid, Mailchimp): Para la gestión del envío de correos electrónicos de activación de cuenta o contacto. Finalidad: Comunicaciones operativas esenciales.'),
            _buildSectionText(
                'Cuando sea requerido por ley o autoridad competente: Para cumplir con una obligación legal, una orden judicial o una solicitud gubernamental.'),
            _buildSectionText(
                'Para proteger derechos de seguridad: Cuando sea necesario para investigar, prevenir o tomar medidas respecto a actividades ilegales, fraudes potenciales, situaciones que impliquen amenazas potenciales a la seguridad física de cualquier persona, o para proteger los derechos, propiedad o seguridad de la Aplicación, nuestros usuarios o del público.'),
            _buildSectionTitle('6. Almacenamiento y Seguridad'),
            _buildSectionText(
                'Tomamos medidas de seguridad técnicas y organizativas adecuadas para proteger la información del usuario contra accesos no autorizados, alteraciones, divulgaciones o destrucción. La información se almacena en servidores seguros con tecnologías de cifrado (en tránsito y en reposo) y acceso restringido y auditado.'),
            _buildSectionTitle('7. Derechos del Usuario'),
            _buildSectionText('El usuario tiene derecho a:'),
            _buildSectionText(
                'Acceder a sus datos personales, en tanto puede obtener la información sobre sí mismo que sea objeto de tratamiento, así como tomar conocimiento sobre la forma en la que fueron obtenidos y las razones de su recopilación.'),
            _buildSectionText(
                'Solicitar rectificación o actualización de sus datos cuando aquellos se encuentren incompletos o inexactos.'),
            _buildSectionText(
                'Requerir la cancelación o supresión de sus datos, siempre que los datos hayan dejado servir para la finalidad por la que fueron obtenidos, culmine el plazo de conservación o se haya solicitado revocatoria previa de tratamiento.'),
            _buildSectionText(
                'Oponerse al tratamiento de sus datos, siempre que existan motivos fundados y legítimos que deriven en una afectación a sus derechos.'),
            _buildSectionText(
                'Solicitar la portabilidad de sus datos, en tanto se facilite de datos a partir de formato estructurado y de lectura mecánica, así como se garantice que el usuario pueda requerir el traslado de datos a otra institución cuando sea técnicamente posible.'),
            _buildSectionText(
                'Revocar su consentimiento en cualquier momento para las finalidades no esenciales (contacto y recomendaciones), sin que esto afecte la licitud del tratamiento basado en el consentimiento previo a su retirada.'),
            _buildSectionText(
                'Solicitar información sobre las condiciones bajo las cuales se trata sus datos.'),
            _buildSectionText(
                'Para ejercer estos derechos, el usuario puede contactar al Delegado de Protección de Datos o equipo de soporte a través del correo: equiposoporte@bimental.com. De considerar que no ha sido atendido en el ejercicio de sus derechos, puede presentar una reclamación ante la Autoridad Nacional de Protección de Datos Personales.'),
            _buildSectionTitle('8. Responsable del Tratamiento de Datos'),
            _buildSectionText('Nombre / Razón Social: Bimental S.A.C.'),
            _buildSectionText('RUC: 36546858374'),
            _buildSectionText(
                'Correo electrónico de contacto: contacto@bimental.com'),
            _buildSectionTitle('9. Conservación de los Datos'),
            _buildSectionText(
                'Los datos personales de los usuarios serán conservados mientras la aplicación se mantenga en uso, salvo que exista un procedimiento administrativo o proceso judicial pendiente sobre los derechos de usuario sobre sus datos o ante indicios de fraude. Se conservarán los datos para finalidades de recomendación y de contacto con profesionales de la salud hasta por el plazo de 3 meses, siempre que haya mediado consentimiento previo por parte del usuario titular de los datos.'),
            _buildSectionTitle('10. Cambios en la Política de Privacidad'),
            _buildSectionText(
                'Nos reservamos el derecho de modificar esta política en cualquier momento. Cualquier cambio sustancial será notificado a los usuarios mediante la Aplicación o a través del correo electrónico proporcionado, dándole la oportunidad de revisar y aceptar los nuevos términos antes de que entren en efecto.'),
            _buildSectionTitle('11. Información adicional'),
            _buildSectionText(
                'Si tienes preguntas sobre esta política, puedes contactarnos a través de serviciocliente@bimental.com.'),
            _buildSectionText(
                'Además, puedes consultar información sobre el cuestionario (explicación, finalidad y sección “Acerca de”) en nuestra página web oficial: www.bimental.com'),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A119B),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child:
                    const Text('Salir', style: TextStyle(color: Colors.white)),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSectionText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
