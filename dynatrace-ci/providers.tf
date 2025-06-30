terraform {
  required_providers {
    dynatrace = {
      version = "1.82.2"
      source  = "dynatrace-oss/dynatrace"
    }

    vault = {
      version = "4.8.0"
    }
  }
}

