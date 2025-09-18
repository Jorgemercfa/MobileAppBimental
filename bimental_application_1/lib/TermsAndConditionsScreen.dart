import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A119B),
        automaticallyImplyLeading: false,
        title: Text(
          'Términos y Condiciones de Uso',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildSectionTitle('1. Aceptación de los Términos'),
            _buildSectionText(
                'Al acceder y utilizar la aplicación móvil Bimental (en adelante, "la Aplicación"), usted acepta cumplir y quedar vinculado por los siguientes Términos y Condiciones de Uso, así como por nuestra Política de Privacidad. Si no está de acuerdo con alguno de estos términos, deberá abstenerse de utilizar la Aplicación.'),
            _buildSectionTitle('2. Naturaleza del Servicio'),
            _buildSectionText(
                'La Aplicación proporciona un sistema de evaluación aproximada basado en el cuestionario DASS-21, utilizando algoritmos de Machine Learning para identificar posibles niveles de depresión, ansiedad y estrés. Los resultados generados son ESTIMACIONES APROXIMADAS y en NINGÚN CASO constituyen un diagnóstico médico profesional, una prescripción terapéutica o un sustituto de la consulta con un profesional de salud mental calificado.'),
            _buildSectionText(
                'Los usuarios comprenden y aceptan que la exactitud de los resultados puede variar y que la Aplicación opera como una herramienta de orientación inicial, no como un servicio de diagnóstico clínico.'),
            _buildSectionTitle('3. Requisitos de Uso'),
            _buildSectionText(
                'Para utilizar la Aplicación, los usuarios deben:'),
            _buildSectionText(
                '- Ser mayor de 18 años o contar con consentimiento parental si son menores de edad.'),
            _buildSectionText(
                '- Proporcionar información veraz y completa durante el registro.'),
            _buildSectionText(
                '- Utilizar la Aplicación de manera responsable y conforme a estos términos.'),
            _buildSectionText(
                '- Aceptar explícitamente el procesamiento de sus datos según lo establecido en la Política de Privacidad.'),
            _buildSectionTitle('4. Limitaciones de Responsabilidad'),
            _buildSectionText('Bimental S.A.C. no asume responsabilidad por:'),
            _buildSectionText(
                '- Decisiones o acciones tomadas por los usuarios basadas en los resultados proporcionados por la Aplicación.'),
            _buildSectionText(
                '- La exactitud, integridad o actualidad de los resultados generados por los algoritmos de Machine Learning.'),
            _buildSectionText(
                '- Consecuencias derivadas de la interpretación o mal uso de la información proporcionada por la Aplicación.'),
            _buildSectionText(
                '- Problemas técnicos, interrupciones o fallos en el servicio que puedan afectar la disponibilidad de la Aplicación.'),
            _buildSectionTitle('5. Propiedad Intelectual'),
            _buildSectionText(
                'Todos los derechos de propiedad intelectual sobre la Aplicación, incluyendo pero no limitándose al software, algoritmos, interfaces, diseños y contenidos, son propiedad exclusiva de Bimental S.A.C. o de sus licenciantes. Queda prohibida la reproducción, distribución o modificación sin autorización expresa.'),
            _buildSectionTitle('6. Conducta del Usuario'),
            _buildSectionText(
                'El usuario se compromete a utilizar la Aplicación de forma lícita y ética, absteniéndose de:'),
            _buildSectionText('- Proporcionar información falsa o engañosa.'),
            _buildSectionText(
                '- Intentar acceder a áreas restringidas o a datos de otros usuarios.'),
            _buildSectionText(
                '- Realizar ingeniería inversa, descompilar o modificar la Aplicación.'),
            _buildSectionText(
                '- Utilizar la Aplicación para fines fraudulentos o ilegales.'),
            _buildSectionTitle('7. Modificaciones del Servicio'),
            _buildSectionText(
                'Bimental S.A.C. se reserva el derecho de modificar, suspender o discontinuar la Aplicación o cualquier parte de ella, en cualquier momento y sin previo aviso. Asimismo, podrá actualizar estos Términos y Condiciones, notificando a los usuarios sobre cambios sustanciales.'),
            _buildSectionTitle('8. Consentimientos Específicos'),
            _buildSectionText(
                'Al utilizar la Aplicación, el usuario otorga su consentimiento explícito para:'),
            _buildSectionText(
                '- El procesamiento de sus datos personales y respuestas según lo establecido en la Política de Privacidad.'),
            _buildSectionText(
                '- Ser contactado por los administradores en caso de que sus resultados alcancen niveles Severo o Extremadamente Severo (si así lo ha aceptado específicamente).'),
            _buildSectionText(
                '- Recibir recomendaciones y recursos de salud mental (si así lo ha aceptado específicamente).'),
            _buildSectionTitle('9. Terminación'),
            _buildSectionText(
                'Bimental S.A.C. podrá suspender o terminar el acceso a la Aplicación a cualquier usuario que incumpla estos Términos y Condiciones, sin perjuicio de otras acciones legales disponibles.'),
            _buildSectionTitle('10. Ley Aplicable y Jurisdicción'),
            _buildSectionText(
                'Estos Términos y Condiciones se regirán e interpretarán de acuerdo con las leyes de Perú. Cualquier disputa relacionada con los mismos será resuelta en los tribunales competentes de Lima, Perú.'),
            _buildSectionTitle('11. Contacto'),
            _buildSectionText(
                'Para cualquier consulta relacionada con estos Términos y Condiciones, puede contactarnos a través de serviciocliente@bimental.com.'),
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
                child: const Text('Aceptar y Continuar',
                    style: TextStyle(color: Colors.white)),
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
