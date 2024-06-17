terraform {
  required_providers {
    dynatrace = {
      version = "1.58.5"
      source  = "dynatrace-oss/dynatrace"
    }

    vault = {
      version = "4.2.0"
    }
  }
}

