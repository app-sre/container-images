terraform {
  required_providers {
    dynatrace = {
      version = "1.69.1"
      source  = "dynatrace-oss/dynatrace"
    }

    vault = {
      version = "4.2.0"
    }
  }
}

