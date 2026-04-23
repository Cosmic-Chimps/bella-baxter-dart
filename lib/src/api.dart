//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:dio/dio.dart';
import 'package:built_value/serializer.dart';
import 'package:bella_baxter/src/serializers.dart';
import 'package:bella_baxter/src/auth/api_key_auth.dart';
import 'package:bella_baxter/src/auth/basic_auth.dart';
import 'package:bella_baxter/src/auth/bearer_auth.dart';
import 'package:bella_baxter/src/auth/oauth.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_access_log_list_access_logs_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_admin_change_admin_password_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_admin_create_admin_user_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_admin_deactivate_user_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_admin_get_project_roles_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_api_keys_create_api_key_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_api_keys_create_personal_api_key_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_api_keys_create_tenant_admin_api_key_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_api_keys_delete_api_key_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_api_keys_delete_personal_api_key_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_api_keys_get_api_key_by_id_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_api_keys_get_environment_api_keys_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_api_keys_get_key_context_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_api_keys_get_personal_api_keys_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_api_keys_issue_environment_token_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_api_keys_toggle_api_key_status_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_api_keys_update_api_key_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_auth_exchange_token_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_auth_get_auth_config_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_auth_get_sso_hint_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_billing_create_billing_portal_session_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_billing_create_checkout_session_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_billing_stripe_webhook_handler_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_dashboard_get_dashboard_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_events_get_sse_stream_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_groups_add_user_to_group_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_groups_create_group_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_groups_delete_group_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_groups_get_group_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_groups_get_group_members_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_groups_list_groups_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_groups_remove_user_from_group_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_groups_update_group_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_notifications_create_notification_channel_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_notifications_delete_notification_channel_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_notifications_get_notification_channel_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_notifications_list_environment_notifications_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_notifications_list_project_notifications_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_notifications_list_tenant_notifications_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_notifications_test_notification_channel_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_notifications_toggle_notification_channel_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_notifications_update_notification_channel_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_assign_project_users_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_assign_providers_to_project_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_create_project_create_project_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_delete_project_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_assign_providers_to_environment_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_assign_users_to_environment_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_copy_environment_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_create_environment_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_delete_environment_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_dynamic_credentials_generate_credentials_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_dynamic_credentials_list_credential_roles_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_get_environment_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_get_environment_drift_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_get_environment_providers_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_get_environment_users_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_get_secret_drift_summary_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_groups_assign_group_to_environment_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_groups_get_environment_groups_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_groups_unassign_group_from_environment_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_leases_list_leases_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_leases_revoke_leases_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_list_environments_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_pki_configure_pki_ca_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_pki_create_pki_role_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_pki_delete_pki_role_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_pki_get_pki_ca_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_pki_issue_pki_certificate_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_pki_list_pki_certificates_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_pki_list_pki_roles_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_pki_revoke_pki_certificate_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_pki_tidy_pki_certs_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_remove_provider_from_environment_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_remove_user_from_environment_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_secrets_create_secret_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_secrets_delete_secret_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_secrets_export_environment_secrets_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_secrets_export_secrets_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_secrets_get_all_environment_secrets_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_secrets_get_environment_secrets_version_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_secrets_get_secret_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_secrets_get_secrets_by_provider_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_secrets_get_secrets_hash_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_secrets_get_secrets_manifest_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_secrets_import_secrets_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_secrets_preview_import_secrets_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_secrets_set_secret_rotation_policy_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_secrets_update_secret_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_secrets_update_secret_metadata_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_secrets_upload_secrets_file_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_secrets_versions_delete_secret_version_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_secrets_versions_destroy_secret_version_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_secrets_versions_get_secret_version_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_secrets_versions_list_secret_versions_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_secrets_versions_rollback_secret_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_secrets_versions_undelete_secret_version_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_ssh_configure_ssh_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_ssh_create_ssh_role_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_ssh_delete_ssh_role_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_ssh_get_ssh_ca_public_key_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_ssh_list_ssh_roles_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_ssh_sign_ssh_key_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_totp_delete_totp_key_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_totp_generate_totp_key_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_totp_get_totp_code_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_totp_import_totp_key_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_totp_list_totp_keys_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_trust_domains_create_trust_domain_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_trust_domains_delete_trust_domain_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_trust_domains_exchange_oidc_token_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_trust_domains_exchange_oidc_token_by_slug_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_trust_domains_get_trust_domain_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_trust_domains_list_trust_domains_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_trust_domains_update_trust_domain_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_update_environment_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_update_environment_user_role_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_environments_update_lease_policy_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_export_project_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_get_project_encryption_key_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_get_project_get_project_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_get_project_users_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_get_secret_drift_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_global_secrets_create_global_secret_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_global_secrets_delete_global_secret_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_global_secrets_list_global_secrets_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_global_secrets_update_global_secret_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_groups_assign_group_to_project_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_groups_get_project_groups_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_groups_unassign_group_from_project_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_import_project_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_list_projects_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_provision_project_dek_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_remove_project_user_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_rotate_project_dek_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_set_global_secret_provider_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_unassign_provider_from_project_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_update_project_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_projects_update_project_user_permissions_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_providers_create_provider_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_providers_delete_provider_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_providers_get_aws_regions_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_providers_get_provider_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_providers_get_provider_catalog_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_providers_get_providers_by_project_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_providers_init_system_provider_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_providers_list_providers_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_providers_search_providers_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_providers_update_provider_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_security_intelligence_get_environment_security_report_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_security_intelligence_get_project_security_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_security_intelligence_get_tenant_security_summary_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_security_intelligence_trigger_environment_scan_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_security_intelligence_trigger_project_global_scan_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_shares_create_share_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_shares_get_share_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_shares_list_my_shares_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_shares_revoke_share_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_shares_unlock_share_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_ssh_list_ssh_logs_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_system_endpoints_diagnostics_endpoint_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_system_endpoints_get_version_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_system_endpoints_system_endpoints_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_tenants_accept_tenant_invite_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_tenants_change_tenant_plan_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_tenants_change_tenant_user_role_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_tenants_configure_oidc_sso_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_tenants_configure_saml_sso_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_tenants_create_own_tenant_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_tenants_create_tenant_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_tenants_create_tenant_invite_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_tenants_download_emergency_kit_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_tenants_get_billing_statements_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_tenants_get_sso_config_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_tenants_get_tenant_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_tenants_get_tenant_encryption_key_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_tenants_get_tenant_invite_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_tenants_get_tenant_usage_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_tenants_list_tenant_invites_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_tenants_list_tenant_users_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_tenants_list_tenants_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_tenants_migrate_tenant_encryption_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_tenants_protected_tenant_endpoint_example_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_tenants_recover_tenant_encryption_key_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_tenants_register_tenant_encryption_key_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_tenants_remove_sso_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_tenants_remove_tenant_user_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_tenants_reprovision_tenant_dek_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_tenants_request_sso_access_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_tenants_revoke_tenant_invite_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_tenants_switch_tenant_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_tenants_tenant_access_endpoints_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_tenants_toggle_sso_enforcement_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_tenants_toggle_zke_enforcement_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_tenants_update_sso_config_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_users_change_user_password_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_users_deactivate_user_account_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_users_get_current_user_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_users_get_user_by_id_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_users_handshake_handshake_endpoint_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_users_reactivate_user_account_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_users_update_current_user_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_webhooks_create_webhook_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_webhooks_deactivate_webhook_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_webhooks_delete_webhook_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_webhooks_get_webhook_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_webhooks_link_webhook_to_provider_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_webhooks_list_environment_webhooks_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_webhooks_list_project_webhooks_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_webhooks_list_tenant_webhooks_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_webhooks_list_webhook_deliveries_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_webhooks_reactivate_webhook_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_webhooks_rotate_webhook_secret_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_webhooks_test_webhook_api.dart';
import 'package:bella_baxter/src/api/bella_baxter_features_webhooks_update_webhook_api.dart';

class BellaBaxter {
  static const String basePath = r'http://localhost:5522';

  final Dio dio;
  final Serializers serializers;

  BellaBaxter({
    Dio? dio,
    Serializers? serializers,
    String? basePathOverride,
    List<Interceptor>? interceptors,
  })  : this.serializers = serializers ?? standardSerializers,
        this.dio = dio ??
            Dio(BaseOptions(
              baseUrl: basePathOverride ?? basePath,
              connectTimeout: const Duration(milliseconds: 5000),
              receiveTimeout: const Duration(milliseconds: 3000),
            )) {
    if (interceptors == null) {
      this.dio.interceptors.addAll([
        OAuthInterceptor(),
        BasicAuthInterceptor(),
        BearerAuthInterceptor(),
        ApiKeyAuthInterceptor(),
      ]);
    } else {
      this.dio.interceptors.addAll(interceptors);
    }
  }

  void setOAuthToken(String name, String token) {
    if (this.dio.interceptors.any((i) => i is OAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is OAuthInterceptor) as OAuthInterceptor).tokens[name] = token;
    }
  }

  void setBearerAuth(String name, String token) {
    if (this.dio.interceptors.any((i) => i is BearerAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is BearerAuthInterceptor) as BearerAuthInterceptor).tokens[name] = token;
    }
  }

  void setBasicAuth(String name, String username, String password) {
    if (this.dio.interceptors.any((i) => i is BasicAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is BasicAuthInterceptor) as BasicAuthInterceptor).authInfo[name] = BasicAuthInfo(username, password);
    }
  }

  void setApiKey(String name, String apiKey) {
    if (this.dio.interceptors.any((i) => i is ApiKeyAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((element) => element is ApiKeyAuthInterceptor) as ApiKeyAuthInterceptor).apiKeys[name] = apiKey;
    }
  }

  /// Get BellaBaxterFeaturesAccessLogListAccessLogsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesAccessLogListAccessLogsApi getBellaBaxterFeaturesAccessLogListAccessLogsApi() {
    return BellaBaxterFeaturesAccessLogListAccessLogsApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesAdminChangeAdminPasswordApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesAdminChangeAdminPasswordApi getBellaBaxterFeaturesAdminChangeAdminPasswordApi() {
    return BellaBaxterFeaturesAdminChangeAdminPasswordApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesAdminCreateAdminUserApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesAdminCreateAdminUserApi getBellaBaxterFeaturesAdminCreateAdminUserApi() {
    return BellaBaxterFeaturesAdminCreateAdminUserApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesAdminDeactivateUserApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesAdminDeactivateUserApi getBellaBaxterFeaturesAdminDeactivateUserApi() {
    return BellaBaxterFeaturesAdminDeactivateUserApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesAdminGetProjectRolesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesAdminGetProjectRolesApi getBellaBaxterFeaturesAdminGetProjectRolesApi() {
    return BellaBaxterFeaturesAdminGetProjectRolesApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesApiKeysCreateApiKeyApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesApiKeysCreateApiKeyApi getBellaBaxterFeaturesApiKeysCreateApiKeyApi() {
    return BellaBaxterFeaturesApiKeysCreateApiKeyApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesApiKeysCreatePersonalApiKeyApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesApiKeysCreatePersonalApiKeyApi getBellaBaxterFeaturesApiKeysCreatePersonalApiKeyApi() {
    return BellaBaxterFeaturesApiKeysCreatePersonalApiKeyApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesApiKeysCreateTenantAdminApiKeyApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesApiKeysCreateTenantAdminApiKeyApi getBellaBaxterFeaturesApiKeysCreateTenantAdminApiKeyApi() {
    return BellaBaxterFeaturesApiKeysCreateTenantAdminApiKeyApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesApiKeysDeleteApiKeyApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesApiKeysDeleteApiKeyApi getBellaBaxterFeaturesApiKeysDeleteApiKeyApi() {
    return BellaBaxterFeaturesApiKeysDeleteApiKeyApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesApiKeysDeletePersonalApiKeyApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesApiKeysDeletePersonalApiKeyApi getBellaBaxterFeaturesApiKeysDeletePersonalApiKeyApi() {
    return BellaBaxterFeaturesApiKeysDeletePersonalApiKeyApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesApiKeysGetApiKeyByIdApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesApiKeysGetApiKeyByIdApi getBellaBaxterFeaturesApiKeysGetApiKeyByIdApi() {
    return BellaBaxterFeaturesApiKeysGetApiKeyByIdApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesApiKeysGetEnvironmentApiKeysApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesApiKeysGetEnvironmentApiKeysApi getBellaBaxterFeaturesApiKeysGetEnvironmentApiKeysApi() {
    return BellaBaxterFeaturesApiKeysGetEnvironmentApiKeysApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesApiKeysGetKeyContextApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesApiKeysGetKeyContextApi getBellaBaxterFeaturesApiKeysGetKeyContextApi() {
    return BellaBaxterFeaturesApiKeysGetKeyContextApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesApiKeysGetPersonalApiKeysApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesApiKeysGetPersonalApiKeysApi getBellaBaxterFeaturesApiKeysGetPersonalApiKeysApi() {
    return BellaBaxterFeaturesApiKeysGetPersonalApiKeysApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesApiKeysIssueEnvironmentTokenApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesApiKeysIssueEnvironmentTokenApi getBellaBaxterFeaturesApiKeysIssueEnvironmentTokenApi() {
    return BellaBaxterFeaturesApiKeysIssueEnvironmentTokenApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesApiKeysToggleApiKeyStatusApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesApiKeysToggleApiKeyStatusApi getBellaBaxterFeaturesApiKeysToggleApiKeyStatusApi() {
    return BellaBaxterFeaturesApiKeysToggleApiKeyStatusApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesApiKeysUpdateApiKeyApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesApiKeysUpdateApiKeyApi getBellaBaxterFeaturesApiKeysUpdateApiKeyApi() {
    return BellaBaxterFeaturesApiKeysUpdateApiKeyApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesAuthExchangeTokenApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesAuthExchangeTokenApi getBellaBaxterFeaturesAuthExchangeTokenApi() {
    return BellaBaxterFeaturesAuthExchangeTokenApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesAuthGetAuthConfigApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesAuthGetAuthConfigApi getBellaBaxterFeaturesAuthGetAuthConfigApi() {
    return BellaBaxterFeaturesAuthGetAuthConfigApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesAuthGetSsoHintApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesAuthGetSsoHintApi getBellaBaxterFeaturesAuthGetSsoHintApi() {
    return BellaBaxterFeaturesAuthGetSsoHintApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesBillingCreateBillingPortalSessionApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesBillingCreateBillingPortalSessionApi getBellaBaxterFeaturesBillingCreateBillingPortalSessionApi() {
    return BellaBaxterFeaturesBillingCreateBillingPortalSessionApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesBillingCreateCheckoutSessionApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesBillingCreateCheckoutSessionApi getBellaBaxterFeaturesBillingCreateCheckoutSessionApi() {
    return BellaBaxterFeaturesBillingCreateCheckoutSessionApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesBillingStripeWebhookHandlerApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesBillingStripeWebhookHandlerApi getBellaBaxterFeaturesBillingStripeWebhookHandlerApi() {
    return BellaBaxterFeaturesBillingStripeWebhookHandlerApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesDashboardGetDashboardApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesDashboardGetDashboardApi getBellaBaxterFeaturesDashboardGetDashboardApi() {
    return BellaBaxterFeaturesDashboardGetDashboardApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesEventsGetSseStreamApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesEventsGetSseStreamApi getBellaBaxterFeaturesEventsGetSseStreamApi() {
    return BellaBaxterFeaturesEventsGetSseStreamApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesGroupsAddUserToGroupApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesGroupsAddUserToGroupApi getBellaBaxterFeaturesGroupsAddUserToGroupApi() {
    return BellaBaxterFeaturesGroupsAddUserToGroupApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesGroupsCreateGroupApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesGroupsCreateGroupApi getBellaBaxterFeaturesGroupsCreateGroupApi() {
    return BellaBaxterFeaturesGroupsCreateGroupApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesGroupsDeleteGroupApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesGroupsDeleteGroupApi getBellaBaxterFeaturesGroupsDeleteGroupApi() {
    return BellaBaxterFeaturesGroupsDeleteGroupApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesGroupsGetGroupApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesGroupsGetGroupApi getBellaBaxterFeaturesGroupsGetGroupApi() {
    return BellaBaxterFeaturesGroupsGetGroupApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesGroupsGetGroupMembersApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesGroupsGetGroupMembersApi getBellaBaxterFeaturesGroupsGetGroupMembersApi() {
    return BellaBaxterFeaturesGroupsGetGroupMembersApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesGroupsListGroupsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesGroupsListGroupsApi getBellaBaxterFeaturesGroupsListGroupsApi() {
    return BellaBaxterFeaturesGroupsListGroupsApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesGroupsRemoveUserFromGroupApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesGroupsRemoveUserFromGroupApi getBellaBaxterFeaturesGroupsRemoveUserFromGroupApi() {
    return BellaBaxterFeaturesGroupsRemoveUserFromGroupApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesGroupsUpdateGroupApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesGroupsUpdateGroupApi getBellaBaxterFeaturesGroupsUpdateGroupApi() {
    return BellaBaxterFeaturesGroupsUpdateGroupApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesNotificationsCreateNotificationChannelApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesNotificationsCreateNotificationChannelApi getBellaBaxterFeaturesNotificationsCreateNotificationChannelApi() {
    return BellaBaxterFeaturesNotificationsCreateNotificationChannelApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesNotificationsDeleteNotificationChannelApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesNotificationsDeleteNotificationChannelApi getBellaBaxterFeaturesNotificationsDeleteNotificationChannelApi() {
    return BellaBaxterFeaturesNotificationsDeleteNotificationChannelApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesNotificationsGetNotificationChannelApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesNotificationsGetNotificationChannelApi getBellaBaxterFeaturesNotificationsGetNotificationChannelApi() {
    return BellaBaxterFeaturesNotificationsGetNotificationChannelApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesNotificationsListEnvironmentNotificationsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesNotificationsListEnvironmentNotificationsApi getBellaBaxterFeaturesNotificationsListEnvironmentNotificationsApi() {
    return BellaBaxterFeaturesNotificationsListEnvironmentNotificationsApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesNotificationsListProjectNotificationsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesNotificationsListProjectNotificationsApi getBellaBaxterFeaturesNotificationsListProjectNotificationsApi() {
    return BellaBaxterFeaturesNotificationsListProjectNotificationsApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesNotificationsListTenantNotificationsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesNotificationsListTenantNotificationsApi getBellaBaxterFeaturesNotificationsListTenantNotificationsApi() {
    return BellaBaxterFeaturesNotificationsListTenantNotificationsApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesNotificationsTestNotificationChannelApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesNotificationsTestNotificationChannelApi getBellaBaxterFeaturesNotificationsTestNotificationChannelApi() {
    return BellaBaxterFeaturesNotificationsTestNotificationChannelApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesNotificationsToggleNotificationChannelApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesNotificationsToggleNotificationChannelApi getBellaBaxterFeaturesNotificationsToggleNotificationChannelApi() {
    return BellaBaxterFeaturesNotificationsToggleNotificationChannelApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesNotificationsUpdateNotificationChannelApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesNotificationsUpdateNotificationChannelApi getBellaBaxterFeaturesNotificationsUpdateNotificationChannelApi() {
    return BellaBaxterFeaturesNotificationsUpdateNotificationChannelApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsAssignProjectUsersApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsAssignProjectUsersApi getBellaBaxterFeaturesProjectsAssignProjectUsersApi() {
    return BellaBaxterFeaturesProjectsAssignProjectUsersApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsAssignProvidersToProjectApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsAssignProvidersToProjectApi getBellaBaxterFeaturesProjectsAssignProvidersToProjectApi() {
    return BellaBaxterFeaturesProjectsAssignProvidersToProjectApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsCreateProjectCreateProjectApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsCreateProjectCreateProjectApi getBellaBaxterFeaturesProjectsCreateProjectCreateProjectApi() {
    return BellaBaxterFeaturesProjectsCreateProjectCreateProjectApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsDeleteProjectApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsDeleteProjectApi getBellaBaxterFeaturesProjectsDeleteProjectApi() {
    return BellaBaxterFeaturesProjectsDeleteProjectApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsAssignProvidersToEnvironmentApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsAssignProvidersToEnvironmentApi getBellaBaxterFeaturesProjectsEnvironmentsAssignProvidersToEnvironmentApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsAssignProvidersToEnvironmentApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsAssignUsersToEnvironmentApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsAssignUsersToEnvironmentApi getBellaBaxterFeaturesProjectsEnvironmentsAssignUsersToEnvironmentApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsAssignUsersToEnvironmentApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsCopyEnvironmentApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsCopyEnvironmentApi getBellaBaxterFeaturesProjectsEnvironmentsCopyEnvironmentApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsCopyEnvironmentApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsCreateEnvironmentApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsCreateEnvironmentApi getBellaBaxterFeaturesProjectsEnvironmentsCreateEnvironmentApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsCreateEnvironmentApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsDeleteEnvironmentApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsDeleteEnvironmentApi getBellaBaxterFeaturesProjectsEnvironmentsDeleteEnvironmentApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsDeleteEnvironmentApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsDynamicCredentialsGenerateCredentialsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsDynamicCredentialsGenerateCredentialsApi getBellaBaxterFeaturesProjectsEnvironmentsDynamicCredentialsGenerateCredentialsApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsDynamicCredentialsGenerateCredentialsApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsDynamicCredentialsListCredentialRolesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsDynamicCredentialsListCredentialRolesApi getBellaBaxterFeaturesProjectsEnvironmentsDynamicCredentialsListCredentialRolesApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsDynamicCredentialsListCredentialRolesApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsGetEnvironmentApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsGetEnvironmentApi getBellaBaxterFeaturesProjectsEnvironmentsGetEnvironmentApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsGetEnvironmentApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsGetEnvironmentDriftApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsGetEnvironmentDriftApi getBellaBaxterFeaturesProjectsEnvironmentsGetEnvironmentDriftApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsGetEnvironmentDriftApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsGetEnvironmentProvidersApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsGetEnvironmentProvidersApi getBellaBaxterFeaturesProjectsEnvironmentsGetEnvironmentProvidersApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsGetEnvironmentProvidersApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsGetEnvironmentUsersApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsGetEnvironmentUsersApi getBellaBaxterFeaturesProjectsEnvironmentsGetEnvironmentUsersApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsGetEnvironmentUsersApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsGetSecretDriftSummaryApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsGetSecretDriftSummaryApi getBellaBaxterFeaturesProjectsEnvironmentsGetSecretDriftSummaryApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsGetSecretDriftSummaryApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsGroupsAssignGroupToEnvironmentApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsGroupsAssignGroupToEnvironmentApi getBellaBaxterFeaturesProjectsEnvironmentsGroupsAssignGroupToEnvironmentApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsGroupsAssignGroupToEnvironmentApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsGroupsGetEnvironmentGroupsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsGroupsGetEnvironmentGroupsApi getBellaBaxterFeaturesProjectsEnvironmentsGroupsGetEnvironmentGroupsApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsGroupsGetEnvironmentGroupsApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsGroupsUnassignGroupFromEnvironmentApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsGroupsUnassignGroupFromEnvironmentApi getBellaBaxterFeaturesProjectsEnvironmentsGroupsUnassignGroupFromEnvironmentApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsGroupsUnassignGroupFromEnvironmentApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsLeasesListLeasesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsLeasesListLeasesApi getBellaBaxterFeaturesProjectsEnvironmentsLeasesListLeasesApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsLeasesListLeasesApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsLeasesRevokeLeasesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsLeasesRevokeLeasesApi getBellaBaxterFeaturesProjectsEnvironmentsLeasesRevokeLeasesApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsLeasesRevokeLeasesApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsListEnvironmentsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsListEnvironmentsApi getBellaBaxterFeaturesProjectsEnvironmentsListEnvironmentsApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsListEnvironmentsApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsPkiConfigurePkiCaApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsPkiConfigurePkiCaApi getBellaBaxterFeaturesProjectsEnvironmentsPkiConfigurePkiCaApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsPkiConfigurePkiCaApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsPkiCreatePkiRoleApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsPkiCreatePkiRoleApi getBellaBaxterFeaturesProjectsEnvironmentsPkiCreatePkiRoleApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsPkiCreatePkiRoleApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsPkiDeletePkiRoleApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsPkiDeletePkiRoleApi getBellaBaxterFeaturesProjectsEnvironmentsPkiDeletePkiRoleApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsPkiDeletePkiRoleApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsPkiGetPkiCaApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsPkiGetPkiCaApi getBellaBaxterFeaturesProjectsEnvironmentsPkiGetPkiCaApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsPkiGetPkiCaApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsPkiIssuePkiCertificateApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsPkiIssuePkiCertificateApi getBellaBaxterFeaturesProjectsEnvironmentsPkiIssuePkiCertificateApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsPkiIssuePkiCertificateApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsPkiListPkiCertificatesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsPkiListPkiCertificatesApi getBellaBaxterFeaturesProjectsEnvironmentsPkiListPkiCertificatesApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsPkiListPkiCertificatesApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsPkiListPkiRolesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsPkiListPkiRolesApi getBellaBaxterFeaturesProjectsEnvironmentsPkiListPkiRolesApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsPkiListPkiRolesApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsPkiRevokePkiCertificateApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsPkiRevokePkiCertificateApi getBellaBaxterFeaturesProjectsEnvironmentsPkiRevokePkiCertificateApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsPkiRevokePkiCertificateApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsPkiTidyPkiCertsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsPkiTidyPkiCertsApi getBellaBaxterFeaturesProjectsEnvironmentsPkiTidyPkiCertsApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsPkiTidyPkiCertsApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsRemoveProviderFromEnvironmentApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsRemoveProviderFromEnvironmentApi getBellaBaxterFeaturesProjectsEnvironmentsRemoveProviderFromEnvironmentApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsRemoveProviderFromEnvironmentApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsRemoveUserFromEnvironmentApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsRemoveUserFromEnvironmentApi getBellaBaxterFeaturesProjectsEnvironmentsRemoveUserFromEnvironmentApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsRemoveUserFromEnvironmentApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsSecretsCreateSecretApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsSecretsCreateSecretApi getBellaBaxterFeaturesProjectsEnvironmentsSecretsCreateSecretApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsSecretsCreateSecretApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsSecretsDeleteSecretApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsSecretsDeleteSecretApi getBellaBaxterFeaturesProjectsEnvironmentsSecretsDeleteSecretApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsSecretsDeleteSecretApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsSecretsExportEnvironmentSecretsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsSecretsExportEnvironmentSecretsApi getBellaBaxterFeaturesProjectsEnvironmentsSecretsExportEnvironmentSecretsApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsSecretsExportEnvironmentSecretsApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsSecretsExportSecretsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsSecretsExportSecretsApi getBellaBaxterFeaturesProjectsEnvironmentsSecretsExportSecretsApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsSecretsExportSecretsApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsSecretsGetAllEnvironmentSecretsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsSecretsGetAllEnvironmentSecretsApi getBellaBaxterFeaturesProjectsEnvironmentsSecretsGetAllEnvironmentSecretsApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsSecretsGetAllEnvironmentSecretsApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsSecretsGetEnvironmentSecretsVersionApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsSecretsGetEnvironmentSecretsVersionApi getBellaBaxterFeaturesProjectsEnvironmentsSecretsGetEnvironmentSecretsVersionApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsSecretsGetEnvironmentSecretsVersionApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsSecretsGetSecretApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsSecretsGetSecretApi getBellaBaxterFeaturesProjectsEnvironmentsSecretsGetSecretApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsSecretsGetSecretApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsSecretsGetSecretsByProviderApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsSecretsGetSecretsByProviderApi getBellaBaxterFeaturesProjectsEnvironmentsSecretsGetSecretsByProviderApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsSecretsGetSecretsByProviderApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsSecretsGetSecretsHashApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsSecretsGetSecretsHashApi getBellaBaxterFeaturesProjectsEnvironmentsSecretsGetSecretsHashApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsSecretsGetSecretsHashApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsSecretsGetSecretsManifestApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsSecretsGetSecretsManifestApi getBellaBaxterFeaturesProjectsEnvironmentsSecretsGetSecretsManifestApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsSecretsGetSecretsManifestApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsSecretsImportSecretsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsSecretsImportSecretsApi getBellaBaxterFeaturesProjectsEnvironmentsSecretsImportSecretsApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsSecretsImportSecretsApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsSecretsPreviewImportSecretsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsSecretsPreviewImportSecretsApi getBellaBaxterFeaturesProjectsEnvironmentsSecretsPreviewImportSecretsApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsSecretsPreviewImportSecretsApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsSecretsSetSecretRotationPolicyApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsSecretsSetSecretRotationPolicyApi getBellaBaxterFeaturesProjectsEnvironmentsSecretsSetSecretRotationPolicyApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsSecretsSetSecretRotationPolicyApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsSecretsUpdateSecretApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsSecretsUpdateSecretApi getBellaBaxterFeaturesProjectsEnvironmentsSecretsUpdateSecretApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsSecretsUpdateSecretApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsSecretsUpdateSecretMetadataApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsSecretsUpdateSecretMetadataApi getBellaBaxterFeaturesProjectsEnvironmentsSecretsUpdateSecretMetadataApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsSecretsUpdateSecretMetadataApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsSecretsUploadSecretsFileApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsSecretsUploadSecretsFileApi getBellaBaxterFeaturesProjectsEnvironmentsSecretsUploadSecretsFileApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsSecretsUploadSecretsFileApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsSecretsVersionsDeleteSecretVersionApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsSecretsVersionsDeleteSecretVersionApi getBellaBaxterFeaturesProjectsEnvironmentsSecretsVersionsDeleteSecretVersionApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsSecretsVersionsDeleteSecretVersionApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsSecretsVersionsDestroySecretVersionApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsSecretsVersionsDestroySecretVersionApi getBellaBaxterFeaturesProjectsEnvironmentsSecretsVersionsDestroySecretVersionApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsSecretsVersionsDestroySecretVersionApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsSecretsVersionsGetSecretVersionApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsSecretsVersionsGetSecretVersionApi getBellaBaxterFeaturesProjectsEnvironmentsSecretsVersionsGetSecretVersionApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsSecretsVersionsGetSecretVersionApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsSecretsVersionsListSecretVersionsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsSecretsVersionsListSecretVersionsApi getBellaBaxterFeaturesProjectsEnvironmentsSecretsVersionsListSecretVersionsApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsSecretsVersionsListSecretVersionsApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsSecretsVersionsRollbackSecretApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsSecretsVersionsRollbackSecretApi getBellaBaxterFeaturesProjectsEnvironmentsSecretsVersionsRollbackSecretApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsSecretsVersionsRollbackSecretApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsSecretsVersionsUndeleteSecretVersionApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsSecretsVersionsUndeleteSecretVersionApi getBellaBaxterFeaturesProjectsEnvironmentsSecretsVersionsUndeleteSecretVersionApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsSecretsVersionsUndeleteSecretVersionApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsSshConfigureSshApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsSshConfigureSshApi getBellaBaxterFeaturesProjectsEnvironmentsSshConfigureSshApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsSshConfigureSshApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsSshCreateSshRoleApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsSshCreateSshRoleApi getBellaBaxterFeaturesProjectsEnvironmentsSshCreateSshRoleApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsSshCreateSshRoleApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsSshDeleteSshRoleApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsSshDeleteSshRoleApi getBellaBaxterFeaturesProjectsEnvironmentsSshDeleteSshRoleApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsSshDeleteSshRoleApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsSshGetSshCaPublicKeyApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsSshGetSshCaPublicKeyApi getBellaBaxterFeaturesProjectsEnvironmentsSshGetSshCaPublicKeyApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsSshGetSshCaPublicKeyApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsSshListSshRolesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsSshListSshRolesApi getBellaBaxterFeaturesProjectsEnvironmentsSshListSshRolesApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsSshListSshRolesApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsSshSignSshKeyApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsSshSignSshKeyApi getBellaBaxterFeaturesProjectsEnvironmentsSshSignSshKeyApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsSshSignSshKeyApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsTotpDeleteTotpKeyApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsTotpDeleteTotpKeyApi getBellaBaxterFeaturesProjectsEnvironmentsTotpDeleteTotpKeyApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsTotpDeleteTotpKeyApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsTotpGenerateTotpKeyApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsTotpGenerateTotpKeyApi getBellaBaxterFeaturesProjectsEnvironmentsTotpGenerateTotpKeyApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsTotpGenerateTotpKeyApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsTotpGetTotpCodeApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsTotpGetTotpCodeApi getBellaBaxterFeaturesProjectsEnvironmentsTotpGetTotpCodeApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsTotpGetTotpCodeApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsTotpImportTotpKeyApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsTotpImportTotpKeyApi getBellaBaxterFeaturesProjectsEnvironmentsTotpImportTotpKeyApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsTotpImportTotpKeyApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsTotpListTotpKeysApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsTotpListTotpKeysApi getBellaBaxterFeaturesProjectsEnvironmentsTotpListTotpKeysApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsTotpListTotpKeysApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsTrustDomainsCreateTrustDomainApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsTrustDomainsCreateTrustDomainApi getBellaBaxterFeaturesProjectsEnvironmentsTrustDomainsCreateTrustDomainApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsTrustDomainsCreateTrustDomainApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsTrustDomainsDeleteTrustDomainApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsTrustDomainsDeleteTrustDomainApi getBellaBaxterFeaturesProjectsEnvironmentsTrustDomainsDeleteTrustDomainApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsTrustDomainsDeleteTrustDomainApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsTrustDomainsExchangeOidcTokenApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsTrustDomainsExchangeOidcTokenApi getBellaBaxterFeaturesProjectsEnvironmentsTrustDomainsExchangeOidcTokenApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsTrustDomainsExchangeOidcTokenApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsTrustDomainsExchangeOidcTokenBySlugApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsTrustDomainsExchangeOidcTokenBySlugApi getBellaBaxterFeaturesProjectsEnvironmentsTrustDomainsExchangeOidcTokenBySlugApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsTrustDomainsExchangeOidcTokenBySlugApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsTrustDomainsGetTrustDomainApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsTrustDomainsGetTrustDomainApi getBellaBaxterFeaturesProjectsEnvironmentsTrustDomainsGetTrustDomainApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsTrustDomainsGetTrustDomainApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsTrustDomainsListTrustDomainsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsTrustDomainsListTrustDomainsApi getBellaBaxterFeaturesProjectsEnvironmentsTrustDomainsListTrustDomainsApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsTrustDomainsListTrustDomainsApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsTrustDomainsUpdateTrustDomainApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsTrustDomainsUpdateTrustDomainApi getBellaBaxterFeaturesProjectsEnvironmentsTrustDomainsUpdateTrustDomainApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsTrustDomainsUpdateTrustDomainApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsUpdateEnvironmentApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsUpdateEnvironmentApi getBellaBaxterFeaturesProjectsEnvironmentsUpdateEnvironmentApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsUpdateEnvironmentApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsUpdateEnvironmentUserRoleApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsUpdateEnvironmentUserRoleApi getBellaBaxterFeaturesProjectsEnvironmentsUpdateEnvironmentUserRoleApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsUpdateEnvironmentUserRoleApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsEnvironmentsUpdateLeasePolicyApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsEnvironmentsUpdateLeasePolicyApi getBellaBaxterFeaturesProjectsEnvironmentsUpdateLeasePolicyApi() {
    return BellaBaxterFeaturesProjectsEnvironmentsUpdateLeasePolicyApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsExportProjectApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsExportProjectApi getBellaBaxterFeaturesProjectsExportProjectApi() {
    return BellaBaxterFeaturesProjectsExportProjectApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsGetProjectEncryptionKeyApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsGetProjectEncryptionKeyApi getBellaBaxterFeaturesProjectsGetProjectEncryptionKeyApi() {
    return BellaBaxterFeaturesProjectsGetProjectEncryptionKeyApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsGetProjectGetProjectApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsGetProjectGetProjectApi getBellaBaxterFeaturesProjectsGetProjectGetProjectApi() {
    return BellaBaxterFeaturesProjectsGetProjectGetProjectApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsGetProjectUsersApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsGetProjectUsersApi getBellaBaxterFeaturesProjectsGetProjectUsersApi() {
    return BellaBaxterFeaturesProjectsGetProjectUsersApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsGetSecretDriftApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsGetSecretDriftApi getBellaBaxterFeaturesProjectsGetSecretDriftApi() {
    return BellaBaxterFeaturesProjectsGetSecretDriftApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsGlobalSecretsCreateGlobalSecretApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsGlobalSecretsCreateGlobalSecretApi getBellaBaxterFeaturesProjectsGlobalSecretsCreateGlobalSecretApi() {
    return BellaBaxterFeaturesProjectsGlobalSecretsCreateGlobalSecretApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsGlobalSecretsDeleteGlobalSecretApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsGlobalSecretsDeleteGlobalSecretApi getBellaBaxterFeaturesProjectsGlobalSecretsDeleteGlobalSecretApi() {
    return BellaBaxterFeaturesProjectsGlobalSecretsDeleteGlobalSecretApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsGlobalSecretsListGlobalSecretsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsGlobalSecretsListGlobalSecretsApi getBellaBaxterFeaturesProjectsGlobalSecretsListGlobalSecretsApi() {
    return BellaBaxterFeaturesProjectsGlobalSecretsListGlobalSecretsApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsGlobalSecretsUpdateGlobalSecretApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsGlobalSecretsUpdateGlobalSecretApi getBellaBaxterFeaturesProjectsGlobalSecretsUpdateGlobalSecretApi() {
    return BellaBaxterFeaturesProjectsGlobalSecretsUpdateGlobalSecretApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsGroupsAssignGroupToProjectApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsGroupsAssignGroupToProjectApi getBellaBaxterFeaturesProjectsGroupsAssignGroupToProjectApi() {
    return BellaBaxterFeaturesProjectsGroupsAssignGroupToProjectApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsGroupsGetProjectGroupsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsGroupsGetProjectGroupsApi getBellaBaxterFeaturesProjectsGroupsGetProjectGroupsApi() {
    return BellaBaxterFeaturesProjectsGroupsGetProjectGroupsApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsGroupsUnassignGroupFromProjectApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsGroupsUnassignGroupFromProjectApi getBellaBaxterFeaturesProjectsGroupsUnassignGroupFromProjectApi() {
    return BellaBaxterFeaturesProjectsGroupsUnassignGroupFromProjectApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsImportProjectApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsImportProjectApi getBellaBaxterFeaturesProjectsImportProjectApi() {
    return BellaBaxterFeaturesProjectsImportProjectApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsListProjectsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsListProjectsApi getBellaBaxterFeaturesProjectsListProjectsApi() {
    return BellaBaxterFeaturesProjectsListProjectsApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsProvisionProjectDekApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsProvisionProjectDekApi getBellaBaxterFeaturesProjectsProvisionProjectDekApi() {
    return BellaBaxterFeaturesProjectsProvisionProjectDekApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsRemoveProjectUserApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsRemoveProjectUserApi getBellaBaxterFeaturesProjectsRemoveProjectUserApi() {
    return BellaBaxterFeaturesProjectsRemoveProjectUserApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsRotateProjectDekApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsRotateProjectDekApi getBellaBaxterFeaturesProjectsRotateProjectDekApi() {
    return BellaBaxterFeaturesProjectsRotateProjectDekApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsSetGlobalSecretProviderApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsSetGlobalSecretProviderApi getBellaBaxterFeaturesProjectsSetGlobalSecretProviderApi() {
    return BellaBaxterFeaturesProjectsSetGlobalSecretProviderApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsUnassignProviderFromProjectApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsUnassignProviderFromProjectApi getBellaBaxterFeaturesProjectsUnassignProviderFromProjectApi() {
    return BellaBaxterFeaturesProjectsUnassignProviderFromProjectApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsUpdateProjectApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsUpdateProjectApi getBellaBaxterFeaturesProjectsUpdateProjectApi() {
    return BellaBaxterFeaturesProjectsUpdateProjectApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProjectsUpdateProjectUserPermissionsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProjectsUpdateProjectUserPermissionsApi getBellaBaxterFeaturesProjectsUpdateProjectUserPermissionsApi() {
    return BellaBaxterFeaturesProjectsUpdateProjectUserPermissionsApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProvidersCreateProviderApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProvidersCreateProviderApi getBellaBaxterFeaturesProvidersCreateProviderApi() {
    return BellaBaxterFeaturesProvidersCreateProviderApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProvidersDeleteProviderApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProvidersDeleteProviderApi getBellaBaxterFeaturesProvidersDeleteProviderApi() {
    return BellaBaxterFeaturesProvidersDeleteProviderApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProvidersGetAwsRegionsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProvidersGetAwsRegionsApi getBellaBaxterFeaturesProvidersGetAwsRegionsApi() {
    return BellaBaxterFeaturesProvidersGetAwsRegionsApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProvidersGetProviderApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProvidersGetProviderApi getBellaBaxterFeaturesProvidersGetProviderApi() {
    return BellaBaxterFeaturesProvidersGetProviderApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProvidersGetProviderCatalogApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProvidersGetProviderCatalogApi getBellaBaxterFeaturesProvidersGetProviderCatalogApi() {
    return BellaBaxterFeaturesProvidersGetProviderCatalogApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProvidersGetProvidersByProjectApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProvidersGetProvidersByProjectApi getBellaBaxterFeaturesProvidersGetProvidersByProjectApi() {
    return BellaBaxterFeaturesProvidersGetProvidersByProjectApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProvidersInitSystemProviderApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProvidersInitSystemProviderApi getBellaBaxterFeaturesProvidersInitSystemProviderApi() {
    return BellaBaxterFeaturesProvidersInitSystemProviderApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProvidersListProvidersApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProvidersListProvidersApi getBellaBaxterFeaturesProvidersListProvidersApi() {
    return BellaBaxterFeaturesProvidersListProvidersApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProvidersSearchProvidersApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProvidersSearchProvidersApi getBellaBaxterFeaturesProvidersSearchProvidersApi() {
    return BellaBaxterFeaturesProvidersSearchProvidersApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesProvidersUpdateProviderApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesProvidersUpdateProviderApi getBellaBaxterFeaturesProvidersUpdateProviderApi() {
    return BellaBaxterFeaturesProvidersUpdateProviderApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesSecurityIntelligenceGetEnvironmentSecurityReportApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesSecurityIntelligenceGetEnvironmentSecurityReportApi getBellaBaxterFeaturesSecurityIntelligenceGetEnvironmentSecurityReportApi() {
    return BellaBaxterFeaturesSecurityIntelligenceGetEnvironmentSecurityReportApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesSecurityIntelligenceGetProjectSecurityApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesSecurityIntelligenceGetProjectSecurityApi getBellaBaxterFeaturesSecurityIntelligenceGetProjectSecurityApi() {
    return BellaBaxterFeaturesSecurityIntelligenceGetProjectSecurityApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesSecurityIntelligenceGetTenantSecuritySummaryApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesSecurityIntelligenceGetTenantSecuritySummaryApi getBellaBaxterFeaturesSecurityIntelligenceGetTenantSecuritySummaryApi() {
    return BellaBaxterFeaturesSecurityIntelligenceGetTenantSecuritySummaryApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesSecurityIntelligenceTriggerEnvironmentScanApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesSecurityIntelligenceTriggerEnvironmentScanApi getBellaBaxterFeaturesSecurityIntelligenceTriggerEnvironmentScanApi() {
    return BellaBaxterFeaturesSecurityIntelligenceTriggerEnvironmentScanApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesSecurityIntelligenceTriggerProjectGlobalScanApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesSecurityIntelligenceTriggerProjectGlobalScanApi getBellaBaxterFeaturesSecurityIntelligenceTriggerProjectGlobalScanApi() {
    return BellaBaxterFeaturesSecurityIntelligenceTriggerProjectGlobalScanApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesSharesCreateShareApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesSharesCreateShareApi getBellaBaxterFeaturesSharesCreateShareApi() {
    return BellaBaxterFeaturesSharesCreateShareApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesSharesGetShareApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesSharesGetShareApi getBellaBaxterFeaturesSharesGetShareApi() {
    return BellaBaxterFeaturesSharesGetShareApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesSharesListMySharesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesSharesListMySharesApi getBellaBaxterFeaturesSharesListMySharesApi() {
    return BellaBaxterFeaturesSharesListMySharesApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesSharesRevokeShareApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesSharesRevokeShareApi getBellaBaxterFeaturesSharesRevokeShareApi() {
    return BellaBaxterFeaturesSharesRevokeShareApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesSharesUnlockShareApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesSharesUnlockShareApi getBellaBaxterFeaturesSharesUnlockShareApi() {
    return BellaBaxterFeaturesSharesUnlockShareApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesSshListSshLogsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesSshListSshLogsApi getBellaBaxterFeaturesSshListSshLogsApi() {
    return BellaBaxterFeaturesSshListSshLogsApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesSystemEndpointsDiagnosticsEndpointApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesSystemEndpointsDiagnosticsEndpointApi getBellaBaxterFeaturesSystemEndpointsDiagnosticsEndpointApi() {
    return BellaBaxterFeaturesSystemEndpointsDiagnosticsEndpointApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesSystemEndpointsGetVersionApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesSystemEndpointsGetVersionApi getBellaBaxterFeaturesSystemEndpointsGetVersionApi() {
    return BellaBaxterFeaturesSystemEndpointsGetVersionApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesSystemEndpointsSystemEndpointsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesSystemEndpointsSystemEndpointsApi getBellaBaxterFeaturesSystemEndpointsSystemEndpointsApi() {
    return BellaBaxterFeaturesSystemEndpointsSystemEndpointsApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesTenantsAcceptTenantInviteApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesTenantsAcceptTenantInviteApi getBellaBaxterFeaturesTenantsAcceptTenantInviteApi() {
    return BellaBaxterFeaturesTenantsAcceptTenantInviteApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesTenantsChangeTenantPlanApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesTenantsChangeTenantPlanApi getBellaBaxterFeaturesTenantsChangeTenantPlanApi() {
    return BellaBaxterFeaturesTenantsChangeTenantPlanApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesTenantsChangeTenantUserRoleApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesTenantsChangeTenantUserRoleApi getBellaBaxterFeaturesTenantsChangeTenantUserRoleApi() {
    return BellaBaxterFeaturesTenantsChangeTenantUserRoleApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesTenantsConfigureOidcSsoApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesTenantsConfigureOidcSsoApi getBellaBaxterFeaturesTenantsConfigureOidcSsoApi() {
    return BellaBaxterFeaturesTenantsConfigureOidcSsoApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesTenantsConfigureSamlSsoApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesTenantsConfigureSamlSsoApi getBellaBaxterFeaturesTenantsConfigureSamlSsoApi() {
    return BellaBaxterFeaturesTenantsConfigureSamlSsoApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesTenantsCreateOwnTenantApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesTenantsCreateOwnTenantApi getBellaBaxterFeaturesTenantsCreateOwnTenantApi() {
    return BellaBaxterFeaturesTenantsCreateOwnTenantApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesTenantsCreateTenantApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesTenantsCreateTenantApi getBellaBaxterFeaturesTenantsCreateTenantApi() {
    return BellaBaxterFeaturesTenantsCreateTenantApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesTenantsCreateTenantInviteApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesTenantsCreateTenantInviteApi getBellaBaxterFeaturesTenantsCreateTenantInviteApi() {
    return BellaBaxterFeaturesTenantsCreateTenantInviteApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesTenantsDownloadEmergencyKitApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesTenantsDownloadEmergencyKitApi getBellaBaxterFeaturesTenantsDownloadEmergencyKitApi() {
    return BellaBaxterFeaturesTenantsDownloadEmergencyKitApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesTenantsGetBillingStatementsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesTenantsGetBillingStatementsApi getBellaBaxterFeaturesTenantsGetBillingStatementsApi() {
    return BellaBaxterFeaturesTenantsGetBillingStatementsApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesTenantsGetSsoConfigApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesTenantsGetSsoConfigApi getBellaBaxterFeaturesTenantsGetSsoConfigApi() {
    return BellaBaxterFeaturesTenantsGetSsoConfigApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesTenantsGetTenantApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesTenantsGetTenantApi getBellaBaxterFeaturesTenantsGetTenantApi() {
    return BellaBaxterFeaturesTenantsGetTenantApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesTenantsGetTenantEncryptionKeyApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesTenantsGetTenantEncryptionKeyApi getBellaBaxterFeaturesTenantsGetTenantEncryptionKeyApi() {
    return BellaBaxterFeaturesTenantsGetTenantEncryptionKeyApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesTenantsGetTenantInviteApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesTenantsGetTenantInviteApi getBellaBaxterFeaturesTenantsGetTenantInviteApi() {
    return BellaBaxterFeaturesTenantsGetTenantInviteApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesTenantsGetTenantUsageApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesTenantsGetTenantUsageApi getBellaBaxterFeaturesTenantsGetTenantUsageApi() {
    return BellaBaxterFeaturesTenantsGetTenantUsageApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesTenantsListTenantInvitesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesTenantsListTenantInvitesApi getBellaBaxterFeaturesTenantsListTenantInvitesApi() {
    return BellaBaxterFeaturesTenantsListTenantInvitesApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesTenantsListTenantUsersApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesTenantsListTenantUsersApi getBellaBaxterFeaturesTenantsListTenantUsersApi() {
    return BellaBaxterFeaturesTenantsListTenantUsersApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesTenantsListTenantsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesTenantsListTenantsApi getBellaBaxterFeaturesTenantsListTenantsApi() {
    return BellaBaxterFeaturesTenantsListTenantsApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesTenantsMigrateTenantEncryptionApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesTenantsMigrateTenantEncryptionApi getBellaBaxterFeaturesTenantsMigrateTenantEncryptionApi() {
    return BellaBaxterFeaturesTenantsMigrateTenantEncryptionApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesTenantsProtectedTenantEndpointExampleApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesTenantsProtectedTenantEndpointExampleApi getBellaBaxterFeaturesTenantsProtectedTenantEndpointExampleApi() {
    return BellaBaxterFeaturesTenantsProtectedTenantEndpointExampleApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesTenantsRecoverTenantEncryptionKeyApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesTenantsRecoverTenantEncryptionKeyApi getBellaBaxterFeaturesTenantsRecoverTenantEncryptionKeyApi() {
    return BellaBaxterFeaturesTenantsRecoverTenantEncryptionKeyApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesTenantsRegisterTenantEncryptionKeyApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesTenantsRegisterTenantEncryptionKeyApi getBellaBaxterFeaturesTenantsRegisterTenantEncryptionKeyApi() {
    return BellaBaxterFeaturesTenantsRegisterTenantEncryptionKeyApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesTenantsRemoveSsoApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesTenantsRemoveSsoApi getBellaBaxterFeaturesTenantsRemoveSsoApi() {
    return BellaBaxterFeaturesTenantsRemoveSsoApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesTenantsRemoveTenantUserApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesTenantsRemoveTenantUserApi getBellaBaxterFeaturesTenantsRemoveTenantUserApi() {
    return BellaBaxterFeaturesTenantsRemoveTenantUserApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesTenantsReprovisionTenantDekApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesTenantsReprovisionTenantDekApi getBellaBaxterFeaturesTenantsReprovisionTenantDekApi() {
    return BellaBaxterFeaturesTenantsReprovisionTenantDekApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesTenantsRequestSsoAccessApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesTenantsRequestSsoAccessApi getBellaBaxterFeaturesTenantsRequestSsoAccessApi() {
    return BellaBaxterFeaturesTenantsRequestSsoAccessApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesTenantsRevokeTenantInviteApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesTenantsRevokeTenantInviteApi getBellaBaxterFeaturesTenantsRevokeTenantInviteApi() {
    return BellaBaxterFeaturesTenantsRevokeTenantInviteApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesTenantsSwitchTenantApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesTenantsSwitchTenantApi getBellaBaxterFeaturesTenantsSwitchTenantApi() {
    return BellaBaxterFeaturesTenantsSwitchTenantApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesTenantsTenantAccessEndpointsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesTenantsTenantAccessEndpointsApi getBellaBaxterFeaturesTenantsTenantAccessEndpointsApi() {
    return BellaBaxterFeaturesTenantsTenantAccessEndpointsApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesTenantsToggleSsoEnforcementApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesTenantsToggleSsoEnforcementApi getBellaBaxterFeaturesTenantsToggleSsoEnforcementApi() {
    return BellaBaxterFeaturesTenantsToggleSsoEnforcementApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesTenantsToggleZkeEnforcementApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesTenantsToggleZkeEnforcementApi getBellaBaxterFeaturesTenantsToggleZkeEnforcementApi() {
    return BellaBaxterFeaturesTenantsToggleZkeEnforcementApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesTenantsUpdateSsoConfigApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesTenantsUpdateSsoConfigApi getBellaBaxterFeaturesTenantsUpdateSsoConfigApi() {
    return BellaBaxterFeaturesTenantsUpdateSsoConfigApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesUsersChangeUserPasswordApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesUsersChangeUserPasswordApi getBellaBaxterFeaturesUsersChangeUserPasswordApi() {
    return BellaBaxterFeaturesUsersChangeUserPasswordApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesUsersDeactivateUserAccountApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesUsersDeactivateUserAccountApi getBellaBaxterFeaturesUsersDeactivateUserAccountApi() {
    return BellaBaxterFeaturesUsersDeactivateUserAccountApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesUsersGetCurrentUserApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesUsersGetCurrentUserApi getBellaBaxterFeaturesUsersGetCurrentUserApi() {
    return BellaBaxterFeaturesUsersGetCurrentUserApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesUsersGetUserByIdApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesUsersGetUserByIdApi getBellaBaxterFeaturesUsersGetUserByIdApi() {
    return BellaBaxterFeaturesUsersGetUserByIdApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesUsersHandshakeHandshakeEndpointApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesUsersHandshakeHandshakeEndpointApi getBellaBaxterFeaturesUsersHandshakeHandshakeEndpointApi() {
    return BellaBaxterFeaturesUsersHandshakeHandshakeEndpointApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesUsersReactivateUserAccountApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesUsersReactivateUserAccountApi getBellaBaxterFeaturesUsersReactivateUserAccountApi() {
    return BellaBaxterFeaturesUsersReactivateUserAccountApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesUsersUpdateCurrentUserApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesUsersUpdateCurrentUserApi getBellaBaxterFeaturesUsersUpdateCurrentUserApi() {
    return BellaBaxterFeaturesUsersUpdateCurrentUserApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesWebhooksCreateWebhookApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesWebhooksCreateWebhookApi getBellaBaxterFeaturesWebhooksCreateWebhookApi() {
    return BellaBaxterFeaturesWebhooksCreateWebhookApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesWebhooksDeactivateWebhookApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesWebhooksDeactivateWebhookApi getBellaBaxterFeaturesWebhooksDeactivateWebhookApi() {
    return BellaBaxterFeaturesWebhooksDeactivateWebhookApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesWebhooksDeleteWebhookApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesWebhooksDeleteWebhookApi getBellaBaxterFeaturesWebhooksDeleteWebhookApi() {
    return BellaBaxterFeaturesWebhooksDeleteWebhookApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesWebhooksGetWebhookApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesWebhooksGetWebhookApi getBellaBaxterFeaturesWebhooksGetWebhookApi() {
    return BellaBaxterFeaturesWebhooksGetWebhookApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesWebhooksLinkWebhookToProviderApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesWebhooksLinkWebhookToProviderApi getBellaBaxterFeaturesWebhooksLinkWebhookToProviderApi() {
    return BellaBaxterFeaturesWebhooksLinkWebhookToProviderApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesWebhooksListEnvironmentWebhooksApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesWebhooksListEnvironmentWebhooksApi getBellaBaxterFeaturesWebhooksListEnvironmentWebhooksApi() {
    return BellaBaxterFeaturesWebhooksListEnvironmentWebhooksApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesWebhooksListProjectWebhooksApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesWebhooksListProjectWebhooksApi getBellaBaxterFeaturesWebhooksListProjectWebhooksApi() {
    return BellaBaxterFeaturesWebhooksListProjectWebhooksApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesWebhooksListTenantWebhooksApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesWebhooksListTenantWebhooksApi getBellaBaxterFeaturesWebhooksListTenantWebhooksApi() {
    return BellaBaxterFeaturesWebhooksListTenantWebhooksApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesWebhooksListWebhookDeliveriesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesWebhooksListWebhookDeliveriesApi getBellaBaxterFeaturesWebhooksListWebhookDeliveriesApi() {
    return BellaBaxterFeaturesWebhooksListWebhookDeliveriesApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesWebhooksReactivateWebhookApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesWebhooksReactivateWebhookApi getBellaBaxterFeaturesWebhooksReactivateWebhookApi() {
    return BellaBaxterFeaturesWebhooksReactivateWebhookApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesWebhooksRotateWebhookSecretApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesWebhooksRotateWebhookSecretApi getBellaBaxterFeaturesWebhooksRotateWebhookSecretApi() {
    return BellaBaxterFeaturesWebhooksRotateWebhookSecretApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesWebhooksTestWebhookApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesWebhooksTestWebhookApi getBellaBaxterFeaturesWebhooksTestWebhookApi() {
    return BellaBaxterFeaturesWebhooksTestWebhookApi(dio, serializers);
  }

  /// Get BellaBaxterFeaturesWebhooksUpdateWebhookApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BellaBaxterFeaturesWebhooksUpdateWebhookApi getBellaBaxterFeaturesWebhooksUpdateWebhookApi() {
    return BellaBaxterFeaturesWebhooksUpdateWebhookApi(dio, serializers);
  }
}
