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
            _buildSectionTitle('1. Introducción'),
            _buildSectionText(
                'Al utilizar esta aplicación móvil, usted acepta los términos y condiciones aquí descritos. Si no está de acuerdo con estos términos, por favor no utilice la aplicación.'),
            _buildSectionTitle('2. Instrucciones de uso de la Aplicación'),
            _buildSectionText(
                'Para usar la aplicación primero debes registrarte en Registrar usuario, llenando tus datos (nombre, apellido, edad, correo electrónico, número de celular, contraseña) y aceptando los Términos y Condiciones y la Política de Privacidad.'),
            _buildSectionText(
                'Con tu cuenta creada ya puedes iniciar sesión. Si olvidas tu contraseña, puedes recuperarla en Olvidé Contraseña.'),
            _buildSectionText(
                'Desde la Home accedes a todo: Chatbot, Resultados, Configuración y Políticas de Privacidad.'),
            _buildSectionText(
                'En el Chatbot solo escribe un mensaje. Para iniciar el cuestionario, escribe "cuestionario" y responde las preguntas (máx. 100 palabras por respuesta).'),
            _buildSectionText(
                'En Resultados verás tu historial y podrás elegir entre el más reciente o uno anterior. Al hacer clic en dicha opción, te aparecerán los niveles de ansiedad, depresión y estrés en (Sin, Leve, Moderado, Severo o Extremadamente Severo).'),
            _buildSectionText(
                'En Configuración puedes activar el modo oscuro para modificar el color de la pantalla o cambiar tus datos (nombre, apellido, correo, celular).'),
            _buildSectionText(
                'Las Políticas de Privacidad están disponibles desde la Home.'),
            _buildSectionText(
                'Para cerrar sesión, toca el botón en la esquina superior derecha.'),
            _buildSectionTitle('3. Finalidad de la Aplicación'),
            _buildSectionText(
                'La aplicación tiene como finalidad proporcionar un sistema de triaje basado en el cuestionario DASS-21. Los resultados proporcionados son aproximaciones generadas por algoritmos de Machine Learning y no constituyen un diagnóstico médico profesional. Deben ser utilizados únicamente como referencia y no sustituyen la evaluación de un profesional de salud mental calificado.'),
            _buildSectionTitle('4. Almacenamiento de Datos'),
            _buildSectionText(
                'Los resultados de las evaluaciones serán almacenados en nuestra base de datos de forma segura. Estos datos podrán ser utilizados por los administradores de la aplicación para generar reportes y contactar a usuarios con resultados de nivel medio o grave. Para mayor información sobre el tratamiento de datos de usuarios, se requiere revisión de la Política de Privacidad.'),
            _buildSectionTitle('5. Seguridad'),
            _buildSectionText(
                'Nos comprometemos a proteger la información de los usuarios. Los datos recopilados no serán compartidos con terceros sin consentimiento, salvo en los casos requeridos por ley. Por ello, se garantiza confidencialidad de la información brindada por el usuario y de aquella derivada de los resultados proporcionados por la aplicación.'),
            _buildSectionText(
                'Asimismo, para evitar brechas o filtraciones de datos sobre usuarios, se aplicará el sistema Firestore Security Rules para garantizar dicha protección. Se comprobará adicionalmente la exactitud de los datos del usuario. Ante la detección de suplantación de identidad, se procederá con la suspensión de la cuenta.'),
            _buildSectionTitle('6. Limitación de Responsabilidad'),
            _buildSectionText(
                'La aplicación no sustituye una consulta con un profesional de salud mental. El usuario es responsable del uso de la información proporcionada y comprende que los resultados son indicativos y no diagnósticos definitivos.'),
            _buildSectionText(
                'La aplicación no se hace responsable por acciones tomadas basadas en los resultados proporcionados, ni por cualquier consecuencia derivada de la interpretación de los mismos.'),
            _buildSectionText(
                'La exactitud de los resultados puede variar y la aplicación no asume responsabilidad por decisiones tomadas basadas en estos resultados. Se recomienda siempre consultar con un profesional de salud mental para una evaluación precisa.'),
            _buildSectionTitle('7. Reclamaciones'),
            _buildSectionText(
                'Ante cualquier reclamo sobre la funcionalidad de la aplicación o sobre los resultados de la evaluación, el usuario puede plantear su reclamo a partir de la siguiente dirección de correo serviciocliente@bimental.com. Asimismo, se ofrece un libro de reclamaciones virtual en el que el usuario puede registrar sus respectivos reclamos sobre la aplicación.'),
            _buildSectionTitle('8. Contacto'),
            _buildSectionText(
                'Si tiene alguna consulta sobre estos términos y condiciones, puede comunicarse con nuestro equipo de soporte en el siguiente correo: equiposoporte@bimental.com'),
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
