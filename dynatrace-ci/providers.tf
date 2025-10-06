terraform {
  required_providers {
    dynatrace = {
      version = "1.58.5"
      source  = "dynatrace-oss/dynatrace"
    }

    vault = {
      version = "5.3.0"
    }
  }
}

