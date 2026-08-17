terraform {
  required_providers {
    dynatrace = {
      version = "1.102.0"
      source  = "dynatrace-oss/dynatrace"
    }

    vault = {
      version = "4.8.0"
    }
  }
}

