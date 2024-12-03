terraform {
  required_providers {
    dynatrace = {
      version = "1.70.0"
      source  = "dynatrace-oss/dynatrace"
    }

    vault = {
      version = "4.2.0"
    }
  }
}

