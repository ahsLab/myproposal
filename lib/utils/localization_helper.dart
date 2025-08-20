import 'package:flutter/material.dart';

class LocalizationHelper {
  static String getString(BuildContext context, String key) {
    final locale = Localizations.localeOf(context).languageCode;
    
    switch (locale) {
      case 'es':
        return _getSpanishString(key);
      case 'tr':
        return _getTurkishString(key);
      default:
        return _getEnglishString(key);
    }
  }
  
  static String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
  
  static String capitalizeWords(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) => capitalizeFirstLetter(word)).join(' ');
  }
  
  static String _getEnglishString(String key) {
    switch (key) {
      case 'appTitle':
        return 'Proposal App';
      case 'appDescription':
        return 'Proposal creation and management application';
      case 'demoMode':
        return 'Demo Mode';
      case 'demoModeDescription':
        return 'In this mode, the data you create is stored only on your device and will be lost when you log in.';
      case 'tryDemoMode':
        return 'Try Demo Mode';
      case 'login':
        return 'Login';
      case 'logout':
        return 'Logout';
      case 'deleteAccount':
        return 'Delete Account';
      case 'deleteAccountConfirmation':
        return 'This action cannot be undone. Your account and all your data will be permanently deleted. Are you sure you want to continue?';
      case 'cancel':
        return 'Cancel';
      case 'confirm':
        return 'Confirm';
      case 'accountDeleted':
        return 'Your account has been successfully deleted';
      case 'accountDeleteError':
        return 'An error occurred while deleting the account';
      case 'darkMode':
        return 'Dark Mode';
      case 'themeChangeNotAvailable':
        return 'Theme change is not yet available.';
      case 'profileSettings':
        return 'Profile & Settings';
      case 'email':
        return 'Email';
      case 'companyManagement':
        return 'Company Management';
      case 'customerManagement':
        return 'Customer Management';
      case 'createProposal':
        return 'Create Proposal';
      case 'proposalHistory':
        return 'Proposal History';
      case 'fullFeaturesLogin':
        return 'Login for Full Features';
      case 'demoCompanyManagement':
        return 'Company Management (Demo)';
      case 'demoCustomerManagement':
        return 'Customer Management (Demo)';
      case 'demoCreateProposal':
        return 'Create Proposal (Demo)';
      case 'demoProposalHistory':
        return 'Proposal History (Demo)';
      case 'language':
        return 'Language';
      case 'pdfLanguage':
        return 'PDF Language';
      case 'english':
        return 'English';
      case 'spanish':
        return 'Spanish';
      case 'turkish':
        return 'Turkish';
      case 'settings':
        return 'Settings';
      case 'languageSettings':
        return 'Language Settings';
      case 'defaultLanguage':
        return 'Default Language';
      case 'defaultPdfLanguage':
        return 'Default PDF Language';
      case 'languageChanged':
        return 'Language changed successfully';
      case 'pdfLanguageChanged':
        return 'PDF language changed successfully';
      case 'contactUs':
        return 'Contact Us';
      case 'feedback':
        return 'Feedback';
      case 'feedbackMessage':
        return 'We\'d love to hear your feedback, suggestions, or report any issues you\'ve encountered.';
      case 'message':
        return 'Message';
      case 'send':
        return 'Send';
      case 'feedbackSent':
        return 'Thank you for your feedback! We\'ll get back to you soon.';
      case 'feedbackError':
        return 'Failed to send feedback. Please try again.';
      case 'enterMessage':
        return 'Please enter your message';
      case 'suggestions':
        return 'Suggestions';
      default:
        return key;
    }
  }
  
  static String _getSpanishString(String key) {
    switch (key) {
      case 'appTitle':
        return 'App de Propuestas';
      case 'appDescription':
        return 'Aplicación de creación y gestión de propuestas';
      case 'demoMode':
        return 'Modo Demo';
      case 'demoModeDescription':
        return 'En este modo, los datos que creas se almacenan solo en tu dispositivo y se perderán cuando inicies sesión.';
      case 'tryDemoMode':
        return 'Probar Modo Demo';
      case 'login':
        return 'Iniciar Sesión';
      case 'logout':
        return 'Cerrar Sesión';
      case 'deleteAccount':
        return 'Eliminar Cuenta';
      case 'deleteAccountConfirmation':
        return 'Esta acción no se puede deshacer. Tu cuenta y todos tus datos se eliminarán permanentemente. ¿Estás seguro de que quieres continuar?';
      case 'cancel':
        return 'Cancelar';
      case 'confirm':
        return 'Confirmar';
      case 'accountDeleted':
        return 'Tu cuenta ha sido eliminada exitosamente';
      case 'accountDeleteError':
        return 'Ocurrió un error al eliminar la cuenta';
      case 'darkMode':
        return 'Modo Oscuro';
      case 'themeChangeNotAvailable':
        return 'El cambio de tema aún no está disponible.';
      case 'profileSettings':
        return 'Perfil y Configuración';
      case 'email':
        return 'Correo Electrónico';
      case 'companyManagement':
        return 'Gestión de Empresas';
      case 'customerManagement':
        return 'Gestión de Clientes';
      case 'createProposal':
        return 'Crear Propuesta';
      case 'proposalHistory':
        return 'Historial de Propuestas';
      case 'fullFeaturesLogin':
        return 'Iniciar Sesión para Funciones Completas';
      case 'demoCompanyManagement':
        return 'Gestión de Empresas (Demo)';
      case 'demoCustomerManagement':
        return 'Gestión de Clientes (Demo)';
      case 'demoCreateProposal':
        return 'Crear Propuesta (Demo)';
      case 'demoProposalHistory':
        return 'Historial de Propuestas (Demo)';
      case 'language':
        return 'Idioma';
      case 'pdfLanguage':
        return 'Idioma del PDF';
      case 'english':
        return 'Inglés';
      case 'spanish':
        return 'Español';
      case 'turkish':
        return 'Turco';
      case 'settings':
        return 'Configuración';
      case 'languageSettings':
        return 'Configuración de Idioma';
      case 'defaultLanguage':
        return 'Idioma Predeterminado';
      case 'defaultPdfLanguage':
        return 'Idioma Predeterminado del PDF';
      case 'languageChanged':
        return 'Idioma cambiado exitosamente';
      case 'pdfLanguageChanged':
        return 'Idioma del PDF cambiado exitosamente';
      case 'contactUs':
        return 'Contáctanos';
      case 'feedback':
        return 'Comentarios';
      case 'feedbackMessage':
        return 'Nos encantaría escuchar tus comentarios, sugerencias o reportar cualquier problema que hayas encontrado.';
      case 'message':
        return 'Mensaje';
      case 'send':
        return 'Enviar';
      case 'feedbackSent':
        return '¡Gracias por tus comentarios! Te responderemos pronto.';
      case 'feedbackError':
        return 'Error al enviar comentarios. Por favor, inténtalo de nuevo.';
      case 'enterMessage':
        return 'Por favor, ingresa tu mensaje';
      case 'suggestions':
        return 'Sugerencias';
      default:
        return _getEnglishString(key);
    }
  }
  
  static String _getTurkishString(String key) {
    switch (key) {
      case 'appTitle':
        return 'Teklif Uygulaması';
      case 'appDescription':
        return 'Teklif oluşturma ve yönetim uygulaması';
      case 'demoMode':
        return 'Demo Modu';
      case 'demoModeDescription':
        return 'Bu modda oluşturduğunuz veriler sadece cihazınızda saklanır ve giriş yaptığınızda kaybolur.';
      case 'tryDemoMode':
        return 'Demo Modunda Dene';
      case 'login':
        return 'Giriş Yap';
      case 'logout':
        return 'Oturumu Kapat';
      case 'deleteAccount':
        return 'Hesabı Sil';
      case 'deleteAccountConfirmation':
        return 'Bu işlem geri alınamaz. Hesabınız ve tüm verileriniz kalıcı olarak silinecektir. Devam etmek istediğinizden emin misiniz?';
      case 'cancel':
        return 'İptal';
      case 'confirm':
        return 'Onayla';
      case 'accountDeleted':
        return 'Hesabınız başarıyla silindi';
      case 'accountDeleteError':
        return 'Hesap silinirken bir hata oluştu';
      case 'darkMode':
        return 'Karanlık Mod';
      case 'themeChangeNotAvailable':
        return 'Tema değiştirme henüz aktif değil.';
      case 'profileSettings':
        return 'Profil & Ayarlar';
      case 'email':
        return 'E-posta';
      case 'companyManagement':
        return 'Firma Yönetimi';
      case 'customerManagement':
        return 'Müşteri Yönetimi';
      case 'createProposal':
        return 'Teklif Oluştur';
      case 'proposalHistory':
        return 'Geçmiş Teklifler';
      case 'fullFeaturesLogin':
        return 'Tam Özellikler İçin Giriş Yap';
      case 'demoCompanyManagement':
        return 'Firma Yönetimi (Demo)';
      case 'demoCustomerManagement':
        return 'Müşteri Yönetimi (Demo)';
      case 'demoCreateProposal':
        return 'Teklif Oluştur (Demo)';
      case 'demoProposalHistory':
        return 'Geçmiş Teklifler (Demo)';
      case 'language':
        return 'Dil';
      case 'pdfLanguage':
        return 'PDF Dili';
      case 'english':
        return 'İngilizce';
      case 'spanish':
        return 'İspanyolca';
      case 'turkish':
        return 'Türkçe';
      case 'settings':
        return 'Ayarlar';
      case 'languageSettings':
        return 'Dil Ayarları';
      case 'defaultLanguage':
        return 'Varsayılan Dil';
      case 'defaultPdfLanguage':
        return 'Varsayılan PDF Dili';
      case 'languageChanged':
        return 'Dil başarıyla değiştirildi';
      case 'pdfLanguageChanged':
        return 'PDF dili başarıyla değiştirildi';
      case 'contactUs':
        return 'Bize Ulaşın';
      case 'feedback':
        return 'Geri Bildirim';
      case 'feedbackMessage':
        return 'Geri bildirimlerinizi, önerilerinizi duymak veya karşılaştığınız sorunları bildirmek isteriz.';
      case 'message':
        return 'Mesaj';
      case 'send':
        return 'Gönder';
      case 'feedbackSent':
        return 'Geri bildiriminiz için teşekkürler! En kısa sürede size dönüş yapacağız.';
      case 'feedbackError':
        return 'Geri bildirim gönderilemedi. Lütfen tekrar deneyin.';
      case 'enterMessage':
        return 'Lütfen mesajınızı girin';
      case 'suggestions':
        return 'Öneriler';
      default:
        return _getEnglishString(key);
    }
  }
}
