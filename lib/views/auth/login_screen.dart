// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../core/theme/app_colors.dart';
// import '../../core/constants/app_strings.dart';
// import '../../viewmodels/auth_viewmodel.dart';
// import '../../viewmodels/product_viewmodel.dart';
// import '../main/main_screen.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _obscurePassword = true;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   Future<void> _login() async {
//     final auth = context.read<AuthViewModel>();
//     final success = await auth.login(
//       _emailController.text.trim(),
//       _passwordController.text.trim(),
//     );
//     if (success && mounted) {
//       await context.read<ProductViewModel>().loadProducts();
//       Navigator.of(
//         context,
//       ).pushReplacement(MaterialPageRoute(builder: (_) => const MainScreen()));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final auth = context.watch<AuthViewModel>();
//     final lang = auth.language;
//     final s = (String key) => AppStrings.get(key, lang);

//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: Row(
//         children: [
//           // ─── Chap: branding panel ───────────────────────────
//           Expanded(
//             flex: 5,
//             child: Container(
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [
//                     Color(0xFF1D4ED8),
//                     Color(0xFF2563EB),
//                     Color(0xFF3B82F6),
//                   ],
//                 ),
//               ),
//               child: Stack(
//                 children: [
//                   // Dekorativ doiralar
//                   Positioned(
//                     top: -60,
//                     left: -60,
//                     child: _Circle(size: 220, opacity: 0.08),
//                   ),
//                   Positioned(
//                     bottom: -80,
//                     right: -40,
//                     child: _Circle(size: 300, opacity: 0.06),
//                   ),
//                   Positioned(
//                     top: 160,
//                     right: -30,
//                     child: _Circle(size: 140, opacity: 0.08),
//                   ),
//                   // Kontent
//                   Center(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Container(
//                           width: 80,
//                           height: 80,
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.15),
//                             borderRadius: BorderRadius.circular(20),
//                             border: Border.all(
//                               color: Colors.white.withOpacity(0.3),
//                               width: 1.5,
//                             ),
//                           ),
//                           child: const Icon(
//                             Icons.restaurant_menu_rounded,
//                             color: Colors.white,
//                             size: 40,
//                           ),
//                         ),
//                         const SizedBox(height: 24),
//                         Text(
//                           s('app_name'),
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 28,
//                             fontWeight: FontWeight.w700,
//                             letterSpacing: -0.5,
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         Text(
//                           lang == 'kr'
//                               ? 'Ресторан бошқаруви тизими'
//                               : 'Restoran boshqaruvi tizimi',
//                           style: TextStyle(
//                             color: Colors.white.withOpacity(0.75),
//                             fontSize: 15,
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                         const SizedBox(height: 48),
//                         // Info kartalar
//                         _InfoCard(
//                           icon: Icons.person_outline_rounded,
//                           label: lang == 'kr' ? 'Официант' : 'Ofitsiant',
//                           sub: 'waiter@test.com / 123456',
//                         ),
//                         const SizedBox(height: 10),
//                         _InfoCard(
//                           icon: Icons.point_of_sale_rounded,
//                           label: lang == 'kr' ? 'Кассир' : 'Kassir',
//                           sub: 'cashier@test.com / 123456',
//                         ),
//                         const SizedBox(height: 10),
//                         _InfoCard(
//                           icon: Icons.admin_panel_settings_outlined,
//                           label: lang == 'kr' ? 'Админ' : 'Admin',
//                           sub: 'admin@test.com / admin123',
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // ─── O'ng: login forma ──────────────────────────────
//           Expanded(
//             flex: 4,
//             child: Container(
//               color: AppColors.surface,
//               padding: const EdgeInsets.symmetric(horizontal: 48),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Til tugmasi
//                   Align(
//                     alignment: Alignment.topRight,
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: 32, bottom: 0),
//                       child: _LangToggle(
//                         lang: lang,
//                         onToggle: () {
//                           context.read<AuthViewModel>().toggleLanguage();
//                         },
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),

//                   Text(
//                     s('login'),
//                     style: const TextStyle(
//                       fontSize: 26,
//                       fontWeight: FontWeight.w700,
//                       color: AppColors.textPrimary,
//                       letterSpacing: -0.5,
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   Text(
//                     lang == 'kr'
//                         ? 'Тизимга кириш учун маълумотларингизни киритинг'
//                         : 'Tizimga kirish uchun ma\'lumotlaringizni kiriting',
//                     style: const TextStyle(
//                       fontSize: 14,
//                       color: AppColors.textSecondary,
//                     ),
//                   ),
//                   const SizedBox(height: 36),

//                   // Email
//                   Text(
//                     'Email',
//                     style: const TextStyle(
//                       fontSize: 13,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.textPrimary,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   TextField(
//                     controller: _emailController,
//                     keyboardType: TextInputType.emailAddress,
//                     onSubmitted: (_) => _login(),
//                     decoration: InputDecoration(
//                       hintText: 'example@mail.com',
//                       prefixIcon: const Icon(
//                         Icons.email_outlined,
//                         color: AppColors.textHint,
//                         size: 20,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),

//                   // Parol
//                   Text(
//                     s('password'),
//                     style: const TextStyle(
//                       fontSize: 13,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.textPrimary,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   TextField(
//                     controller: _passwordController,
//                     obscureText: _obscurePassword,
//                     onSubmitted: (_) => _login(),
//                     decoration: InputDecoration(
//                       hintText: s('enter_password'),
//                       prefixIcon: const Icon(
//                         Icons.lock_outline_rounded,
//                         color: AppColors.textHint,
//                         size: 20,
//                       ),
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           _obscurePassword
//                               ? Icons.visibility_off_outlined
//                               : Icons.visibility_outlined,
//                           color: AppColors.textHint,
//                           size: 20,
//                         ),
//                         onPressed: () => setState(
//                           () => _obscurePassword = !_obscurePassword,
//                         ),
//                       ),
//                     ),
//                   ),

//                   // Xato
//                   if (auth.error != null) ...[
//                     const SizedBox(height: 14),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 14,
//                         vertical: 10,
//                       ),
//                       decoration: BoxDecoration(
//                         color: AppColors.error.withOpacity(0.08),
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(
//                           color: AppColors.error.withOpacity(0.2),
//                         ),
//                       ),
//                       child: Row(
//                         children: [
//                           const Icon(
//                             Icons.error_outline,
//                             color: AppColors.error,
//                             size: 16,
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: Text(
//                               auth.error!,
//                               style: const TextStyle(
//                                 color: AppColors.error,
//                                 fontSize: 13,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],

//                   const SizedBox(height: 28),

//                   // Kirish tugmasi
//                   SizedBox(
//                     width: double.infinity,
//                     height: 52,
//                     child: ElevatedButton(
//                       onPressed: auth.isLoading ? null : _login,
//                       child: auth.isLoading
//                           ? const SizedBox(
//                               width: 22,
//                               height: 22,
//                               child: CircularProgressIndicator(
//                                 color: Colors.white,
//                                 strokeWidth: 2.5,
//                               ),
//                             )
//                           : Text(s('login')),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─── Yordamchi widgetlar ─────────────────────────────────────

// class _Circle extends StatelessWidget {
//   final double size;
//   final double opacity;
//   const _Circle({required this.size, required this.opacity});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: size,
//       height: size,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: Colors.white.withOpacity(opacity),
//       ),
//     );
//   }
// }

// class _InfoCard extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final String sub;
//   const _InfoCard({required this.icon, required this.label, required this.sub});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 260,
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: Colors.white.withOpacity(0.15)),
//       ),
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.white, size: 18),
//           const SizedBox(width: 12),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 13,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               Text(
//                 sub,
//                 style: TextStyle(
//                   color: Colors.white.withOpacity(0.65),
//                   fontSize: 11,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _LangToggle extends StatelessWidget {
//   final String lang;
//   final VoidCallback onToggle;
//   const _LangToggle({required this.lang, required this.onToggle});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onToggle,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//         decoration: BoxDecoration(
//           color: AppColors.surfaceSecondary,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(color: AppColors.border),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               'UZ',
//               style: TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.w600,
//                 color: lang == 'uz'
//                     ? AppColors.primary
//                     : AppColors.textSecondary,
//               ),
//             ),
//             const SizedBox(width: 6),
//             Container(width: 1, height: 14, color: AppColors.border),
//             const SizedBox(width: 6),
//             Text(
//               'КР',
//               style: TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.w600,
//                 color: lang == 'kr'
//                     ? AppColors.primary
//                     : AppColors.textSecondary,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
