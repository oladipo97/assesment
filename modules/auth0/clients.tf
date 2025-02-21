resource "auth0_client" "state_dashboard_client" {
  name                       = "State Dashboard"
  description                = "The web client for the State Dashboard app in the 120Water platform."
  app_type                   = "spa"
  cross_origin_auth          = true         
  allowed_origins            = var.state_dashboard_hostnames
  allowed_logout_urls        = var.state_dashboard_hostnames
  callbacks                  = var.state_dashboard_hostnames
  web_origins                = var.state_dashboard_hostnames
  oidc_conformant            = true
  grant_types                = ["implicit", "password", "refresh_token", "authorization_code", 
    "http://auth0.com/oauth/grant-type/mfa-oob", "http://auth0.com/oauth/grant-type/mfa-otp",
    "http://auth0.com/oauth/grant-type/mfa-recovery-code"]
  sso                        = true
  client_metadata = {
    "required_roles" = "StateDashboard"
  }
}

resource "auth0_client" "hydra_client" {
  name                       = "PWS Insights"
  description                = "The web client for the PWS Insights app in the 120Water platform."
  app_type                   = "spa"
  cross_origin_auth          = true
  allowed_origins            = var.hydra_hostnames
  allowed_logout_urls        = var.hydra_hostnames
  callbacks                  = var.hydra_hostnames
  web_origins                = var.hydra_hostnames
  oidc_conformant            = true
  grant_types                = ["implicit", "password", "refresh_token", "authorization_code",
    "http://auth0.com/oauth/grant-type/mfa-oob", "http://auth0.com/oauth/grant-type/mfa-otp",
    "http://auth0.com/oauth/grant-type/mfa-recovery-code"]
  sso                        = true
  client_metadata = {
    "required_roles" = "Hydra"
  }
}
