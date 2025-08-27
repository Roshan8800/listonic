import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/bottom_navigation_widget.dart';
import './widgets/settings_section.dart';
import './widgets/subscription_card.dart';
import './widgets/user_profile_card.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  bool _notificationsEnabled = true;
  bool _locationEnabled = true;
  bool _analyticsEnabled = false;
  bool _marketingEnabled = true;
  bool _biometricEnabled = true;
  String _selectedTheme = 'Auto';
  String _selectedLanguage = 'English';
  String _selectedCurrency = 'USD';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text(
          "Profile Settings",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              _showHelpDialog(context);
            },
            icon: CustomIconWidget(
              iconName: 'help_outline',
              color: isDark
                  ? AppTheme.textHighEmphasisDark
                  : AppTheme.textHighEmphasisLight,
              size: 24,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Profile Card
              const UserProfileCard(),

              SizedBox(height: 2.h),

              // Subscription Card
              const SubscriptionCard(),

              SizedBox(height: 2.h),

              // Account Settings Section
              SettingsSection(
                title: "Account",
                items: [
                  SettingsItem(
                    iconName: 'person_outline',
                    iconColor:
                        isDark ? AppTheme.primaryDark : AppTheme.primaryLight,
                    title: "Personal Information",
                    subtitle: "Name, email, phone number",
                    onTap: () => _navigateToPersonalInfo(context),
                  ),
                  SettingsItem(
                    iconName: 'lock_outline',
                    iconColor: Colors.orange,
                    title: "Password & Security",
                    subtitle: "Change password, 2FA settings",
                    onTap: () => _navigateToSecurity(context),
                  ),
                  SettingsItem(
                    iconName: 'fingerprint',
                    iconColor: Colors.purple,
                    title: "Biometric Settings",
                    subtitle: _biometricEnabled ? "Enabled" : "Disabled",
                    trailing: Switch(
                      value: _biometricEnabled,
                      onChanged: (value) {
                        setState(() {
                          _biometricEnabled = value;
                        });
                        _showBiometricDialog(context, value);
                      },
                    ),
                  ),
                  SettingsItem(
                    iconName: 'link',
                    iconColor: Colors.blue,
                    title: "Connected Accounts",
                    subtitle: "Google, Apple, Facebook",
                    onTap: () => _navigateToConnectedAccounts(context),
                  ),
                ],
              ),

              // Preferences Section
              SettingsSection(
                title: "Preferences",
                items: [
                  SettingsItem(
                    iconName: 'restaurant',
                    iconColor: Colors.green,
                    title: "Dietary Restrictions",
                    subtitle: "Vegetarian, Gluten-free, etc.",
                    onTap: () => _navigateToDietaryRestrictions(context),
                  ),
                  SettingsItem(
                    iconName: 'warning_amber',
                    iconColor: Colors.red,
                    title: "Allergen Warnings",
                    subtitle: "Nuts, Dairy, Shellfish",
                    onTap: () => _navigateToAllergenWarnings(context),
                  ),
                  SettingsItem(
                    iconName: 'store',
                    iconColor: Colors.teal,
                    title: "Preferred Stores",
                    subtitle: "Walmart, Target, Kroger",
                    onTap: () => _navigateToPreferredStores(context),
                  ),
                  SettingsItem(
                    iconName: 'notifications_outlined',
                    iconColor: Colors.indigo,
                    title: "Shopping Notifications",
                    subtitle: _notificationsEnabled ? "Enabled" : "Disabled",
                    trailing: Switch(
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
                      },
                    ),
                  ),
                ],
              ),

              // App Settings Section
              SettingsSection(
                title: "App Settings",
                items: [
                  SettingsItem(
                    iconName: 'palette_outlined',
                    iconColor: Colors.pink,
                    title: "Theme Selection",
                    subtitle: _selectedTheme,
                    onTap: () => _showThemeDialog(context),
                  ),
                  SettingsItem(
                    iconName: 'language',
                    iconColor: Colors.cyan,
                    title: "Language",
                    subtitle: _selectedLanguage,
                    onTap: () => _showLanguageDialog(context),
                  ),
                  SettingsItem(
                    iconName: 'attach_money',
                    iconColor: Colors.amber,
                    title: "Currency",
                    subtitle: _selectedCurrency,
                    onTap: () => _showCurrencyDialog(context),
                  ),
                  SettingsItem(
                    iconName: 'straighten',
                    iconColor: Colors.deepOrange,
                    title: "Units of Measurement",
                    subtitle: "Imperial (lbs, oz, °F)",
                    onTap: () => _showUnitsDialog(context),
                  ),
                ],
              ),

              // Privacy Section
              SettingsSection(
                title: "Privacy",
                items: [
                  SettingsItem(
                    iconName: 'share',
                    iconColor: Colors.lightBlue,
                    title: "Data Sharing",
                    subtitle: "Control data sharing preferences",
                    onTap: () => _navigateToDataSharing(context),
                  ),
                  SettingsItem(
                    iconName: 'location_on_outlined',
                    iconColor: Colors.red,
                    title: "Location Services",
                    subtitle: _locationEnabled ? "Enabled" : "Disabled",
                    trailing: Switch(
                      value: _locationEnabled,
                      onChanged: (value) {
                        setState(() {
                          _locationEnabled = value;
                        });
                        _showLocationDialog(context, value);
                      },
                    ),
                  ),
                  SettingsItem(
                    iconName: 'analytics',
                    iconColor: Colors.deepPurple,
                    title: "Analytics",
                    subtitle: _analyticsEnabled ? "Enabled" : "Disabled",
                    trailing: Switch(
                      value: _analyticsEnabled,
                      onChanged: (value) {
                        setState(() {
                          _analyticsEnabled = value;
                        });
                      },
                    ),
                  ),
                  SettingsItem(
                    iconName: 'campaign',
                    iconColor: Colors.orange,
                    title: "Marketing Communications",
                    subtitle: _marketingEnabled ? "Enabled" : "Disabled",
                    trailing: Switch(
                      value: _marketingEnabled,
                      onChanged: (value) {
                        setState(() {
                          _marketingEnabled = value;
                        });
                      },
                    ),
                  ),
                ],
              ),

              // Family Sharing Section
              SettingsSection(
                title: "Family Sharing",
                items: [
                  SettingsItem(
                    iconName: 'group_add',
                    iconColor: Colors.green,
                    title: "Invite Family Members",
                    subtitle: "Share lists with family",
                    onTap: () => _navigateToFamilyInvite(context),
                  ),
                  SettingsItem(
                    iconName: 'admin_panel_settings',
                    iconColor: Colors.blue,
                    title: "Permission Controls",
                    subtitle: "Manage family permissions",
                    onTap: () => _navigateToPermissions(context),
                  ),
                  SettingsItem(
                    iconName: 'people',
                    iconColor: Colors.purple,
                    title: "Family Members",
                    subtitle: "3 members connected",
                    onTap: () => _navigateToFamilyMembers(context),
                  ),
                ],
              ),

              // Support & Legal Section
              SettingsSection(
                title: "Support & Legal",
                items: [
                  SettingsItem(
                    iconName: 'help_center',
                    iconColor: Colors.teal,
                    title: "Help Center",
                    subtitle: "FAQs and support articles",
                    onTap: () => _navigateToHelpCenter(context),
                  ),
                  SettingsItem(
                    iconName: 'contact_support',
                    iconColor: Colors.indigo,
                    title: "Contact Support",
                    subtitle: "Get help from our team",
                    onTap: () => _navigateToContactSupport(context),
                  ),
                  SettingsItem(
                    iconName: 'privacy_tip',
                    iconColor: Colors.grey,
                    title: "Privacy Policy",
                    onTap: () => _navigateToPrivacyPolicy(context),
                  ),
                  SettingsItem(
                    iconName: 'description',
                    iconColor: Colors.grey,
                    title: "Terms of Service",
                    onTap: () => _navigateToTermsOfService(context),
                  ),
                ],
              ),

              // Danger Zone
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                      child: Text(
                        "Danger Zone",
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.red.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 1.h),
                        leading: Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CustomIconWidget(
                            iconName: 'delete_forever',
                            color: Colors.red,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          "Delete Account",
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red,
                                  ),
                        ),
                        subtitle: Text(
                          "Permanently delete your account and all data",
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.red.withValues(alpha: 0.7),
                                  ),
                        ),
                        trailing: CustomIconWidget(
                          iconName: 'chevron_right',
                          color: Colors.red,
                          size: 20,
                        ),
                        onTap: () => _showDeleteAccountDialog(context),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10.h), // Bottom padding for navigation
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavigationWidget(currentIndex: 4),
    );
  }

  void _navigateToPersonalInfo(BuildContext context) {
    // Navigate to personal information screen
  }

  void _navigateToSecurity(BuildContext context) {
    // Navigate to security settings screen
  }

  void _navigateToConnectedAccounts(BuildContext context) {
    // Navigate to connected accounts screen
  }

  void _navigateToDietaryRestrictions(BuildContext context) {
    // Navigate to dietary restrictions screen
  }

  void _navigateToAllergenWarnings(BuildContext context) {
    // Navigate to allergen warnings screen
  }

  void _navigateToPreferredStores(BuildContext context) {
    // Navigate to preferred stores screen
  }

  void _navigateToDataSharing(BuildContext context) {
    // Navigate to data sharing screen
  }

  void _navigateToFamilyInvite(BuildContext context) {
    // Navigate to family invite screen
  }

  void _navigateToPermissions(BuildContext context) {
    // Navigate to permissions screen
  }

  void _navigateToFamilyMembers(BuildContext context) {
    // Navigate to family members screen
  }

  void _navigateToHelpCenter(BuildContext context) {
    // Navigate to help center screen
  }

  void _navigateToContactSupport(BuildContext context) {
    // Navigate to contact support screen
  }

  void _navigateToPrivacyPolicy(BuildContext context) {
    // Navigate to privacy policy screen
  }

  void _navigateToTermsOfService(BuildContext context) {
    // Navigate to terms of service screen
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Need Help?",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Here are some quick tips for managing your profile settings:",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            const Text("• Tap any setting to modify it"),
            const Text("• Use switches to quickly toggle features"),
            const Text("• Check subscription status in the premium card"),
            const Text("• Family sharing allows collaborative lists"),
            SizedBox(height: 2.h),
            Text(
              "For more detailed help, visit our Help Center.",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Got it"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToHelpCenter(context);
            },
            child: const Text("Help Center"),
          ),
        ],
      ),
    );
  }

  void _showBiometricDialog(BuildContext context, bool enabled) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          enabled
              ? "Biometric Authentication Enabled"
              : "Biometric Authentication Disabled",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        content: Text(
          enabled
              ? "You can now use your fingerprint or face to unlock the app and authorize sensitive actions."
              : "Biometric authentication has been disabled. You'll need to use your password for sensitive actions.",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showLocationDialog(BuildContext context, bool enabled) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          enabled ? "Location Services Enabled" : "Location Services Disabled",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        content: Text(
          enabled
              ? "The app can now access your location to find nearby stores and provide location-based recommendations."
              : "Location services have been disabled. Some features like store finder may not work properly.",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Select Theme",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text("Light"),
              value: "Light",
              groupValue: _selectedTheme,
              onChanged: (value) {
                setState(() {
                  _selectedTheme = value!;
                });
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text("Dark"),
              value: "Dark",
              groupValue: _selectedTheme,
              onChanged: (value) {
                setState(() {
                  _selectedTheme = value!;
                });
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text("Auto (System)"),
              value: "Auto",
              groupValue: _selectedTheme,
              onChanged: (value) {
                setState(() {
                  _selectedTheme = value!;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final languages = [
      "English",
      "Spanish",
      "French",
      "German",
      "Italian",
      "Portuguese"
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Select Language",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: languages.length,
            itemBuilder: (context, index) {
              final language = languages[index];
              return RadioListTile<String>(
                title: Text(language),
                value: language,
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value!;
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showCurrencyDialog(BuildContext context) {
    final currencies = ["USD", "EUR", "GBP", "CAD", "AUD", "JPY"];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Select Currency",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: currencies.length,
            itemBuilder: (context, index) {
              final currency = currencies[index];
              return RadioListTile<String>(
                title: Text(currency),
                value: currency,
                groupValue: _selectedCurrency,
                onChanged: (value) {
                  setState(() {
                    _selectedCurrency = value!;
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showUnitsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Units of Measurement",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text("Imperial (lbs, oz, °F)"),
              value: "Imperial",
              groupValue: "Imperial",
              onChanged: (value) {
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text("Metric (kg, g, °C)"),
              value: "Metric",
              groupValue: "Imperial",
              onChanged: (value) {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Delete Account",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "This action cannot be undone. Deleting your account will:",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            SizedBox(height: 2.h),
            const Text("• Permanently delete all your grocery lists"),
            const Text("• Remove all saved preferences and settings"),
            const Text("• Cancel your premium subscription"),
            const Text("• Delete all shopping history and analytics"),
            const Text("• Remove you from all family sharing groups"),
            SizedBox(height: 2.h),
            Text(
              "Are you absolutely sure you want to delete your account?",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showFinalDeleteConfirmation(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text("Delete Account"),
          ),
        ],
      ),
    );
  }

  void _showFinalDeleteConfirmation(BuildContext context) {
    final TextEditingController confirmController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          "Final Confirmation",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Type 'DELETE' to confirm account deletion:",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: confirmController,
              decoration: const InputDecoration(
                hintText: "Type DELETE here",
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.characters,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          StatefulBuilder(
            builder: (context, setState) => ElevatedButton(
              onPressed: confirmController.text == 'DELETE'
                  ? () {
                      Navigator.pop(context);
                      // Handle account deletion
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text("Delete Forever"),
            ),
          ),
        ],
      ),
    );
  }
}
