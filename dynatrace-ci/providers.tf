terraform {
  required_providers {
    dynatrace = {
      version = "1.71.0"
      source  = "dynatrace-oss/dynatrace"
    }

    vault = {
      version = "4.2.0"
    }
  }
}

