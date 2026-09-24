class AppRoutes {
  // Splash & Welcome
  static const splash = '/splash';
  static const welcome = '/welcome';
  static const notServiceable = '/not-serviceable';

  // Auth
  static const login = '/login';
  static const otpVerification = '/otp-verification';

  // Customer
  static const customerLocation = '/customer/location';
  static const customerHome = '/customer/home';
  static const customerExplore = '/customer/explore';
  static const customerCategories = '/customer/home/categories';
  static const customerCategoryDetails = '/customer/home/categories/:categoryId';
  static const customerServiceDetails = '/customer/home/service/:serviceId';
  static const customerSearch = '/customer/home/search';
  static const customerWorkers = '/customer/home/workers';
  static const customerWorkerProfile = '/customer/home/worker/:workerId';
  static const customerEnquiryCreate = '/customer/enquiry/create';
  static const customerEnquiryReview = '/customer/enquiry/review';
  static const customerEnquirySuccess = '/customer/enquiry/success';
  static const customerEnquiries = '/customer/enquiries';
  static const customerEnquiryDetails = '/customer/enquiries/:enquiryId';
  static const customerBookings = '/customer/bookings';
  static const customerBookingDetails = '/customer/bookings/:bookingId';
  static const customerProperties = '/customer/home/properties';
  static const customerPropertyDetails = '/customer/home/property/:propertyId';
  static const customerPropertyEnquiry = '/customer/property-enquiry';
  static const customerNotifications = '/customer/home/notifications';
  static const customerProfile = '/customer/profile';
  static const customerEditProfile = '/customer/profile/edit';
  static const customerSettings = '/customer/profile/settings';
  static const customerSavedWorkers = '/customer/profile/saved-workers';
  static const customerSavedProperties = '/customer/profile/saved-properties';
  static const customerSupport = '/customer/profile/support';
  static const customerReviews = '/customer/reviews';

  // Worker
  static const workerRegister = '/worker/register';
  static const workerProfileSetup = '/worker/profile-setup';
  static const workerVerification = '/worker/verification';
  static const workerDashboard = '/worker/dashboard';
  static const workerEnquiries = '/worker/enquiries';
  static const workerEnquiryDetails = '/worker/enquiry/:enquiryId';
  static const workerJobs = '/worker/jobs';
  static const workerJobDetails = '/worker/job/:jobId';
  static const workerEarnings = '/worker/earnings';
  static const workerProfile = '/worker/profile';
  static const workerEditProfile = '/worker/edit-profile';
  static const workerSettings = '/worker/settings';

  // Admin
  static const adminLogin = '/admin/login';
  static const adminDashboard = '/admin/dashboard';
  static const adminUsers = '/admin/users';
  static const adminUserDetails = '/admin/users/:userId';
  static const adminWorkers = '/admin/workers';
  static const adminWorkerDetails = '/admin/workers/:workerId';
  static const adminServices = '/admin/services';
  static const adminCategories = '/admin/categories';
  static const adminEnquiries = '/admin/enquiries';
  static const adminEnquiryDetails = '/admin/enquiries/:enquiryId';
  static const adminBookings = '/admin/bookings';
  static const adminBookingDetails = '/admin/bookings/:bookingId';
  static const adminProperties = '/admin/properties';
  static const adminPropertyDetails = '/admin/properties/:propertyId';
  static const adminAdvertisements = '/admin/advertisements';
  static const adminReviews = '/admin/reviews';
  static const adminSupport = '/admin/support';
  static const adminSupportDetails = '/admin/support/:ticketId';
  static const adminReports = '/admin/reports';
  static const adminSettings = '/admin/settings';

  // Legal & Support
  static const privacyPolicy = '/privacy-policy';
  static const termsOfService = '/terms-of-service';
  static const faqs = '/faqs';

  // Error
  static const error = '/404';

  /// Helper methods for routes with parameters
  static String getCategoryDetailsRoute(String categoryId) => '/customer/home/categories/$categoryId';
  static String getServiceDetailsRoute(String serviceId) => '/customer/home/service/$serviceId';
  static String getWorkerProfileRoute(String workerId) => '/customer/home/worker/$workerId';
  static String getEnquiryDetailsRoute(String enquiryId) => '/customer/enquiries/$enquiryId';
  static String getBookingDetailsRoute(String bookingId) => '/customer/bookings/$bookingId';
  static String getPropertyDetailsRoute(String propertyId) => '/customer/home/property/$propertyId';
  
  static String getWorkerJobDetailsRoute(String jobId) => '/worker/jobs/$jobId';
  static String getWorkerEnquiryDetailsRoute(String enquiryId) => '/worker/enquiries/$enquiryId';
  
  static String getAdminUserDetailsRoute(String userId) => '/admin/users/$userId';
  static String getAdminWorkerDetailsRoute(String workerId) => '/admin/workers/$workerId';
  static String getAdminEnquiryDetailsRoute(String enquiryId) => '/admin/enquiries/$enquiryId';
  static String getAdminBookingDetailsRoute(String bookingId) => '/admin/bookings/$bookingId';
  static String getAdminPropertyDetailsRoute(String propertyId) => '/admin/properties/$propertyId';
  static String getAdminSupportDetailsRoute(String ticketId) => '/admin/support/$ticketId';
}
