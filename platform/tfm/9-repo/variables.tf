variable "project" {
    type = string
    description = "Project Name"
}

variable "region" {
    type = string
    description = "GCP Region"
}

variable "repoid" {
    type = string
    description = "The last part of the repository name"
}

variable "repoexists" {
    type = bool
    description = "Pre-run computed value if registry already exists"
}

variable "remoteregistry" {
    type = string
    description = "Address of remote registry"
}

variable "remotehelm" {
    type = string
    description = "Address of remote registry"
}

variable "remoteregistry_user" {
    type = string
    description = "Remote registry user"
}

variable "remoteregistry_pass" {
    type = string
    description = "Remote registry user password"
}

# Those are images and charts hosted on jFrog edge
# For third-party images and charts you should make your own arrangememnts
# Once initially sed - comment them out only to pull latest version you may need.

variable "images" {
    type = map
    default = {

/*         "voice/agent_node" = "100.0.1000013"
        "voice/callthread_node" = "100.0.1000013"
        "voice/config_node" = "100.0.1000010"
        "voice/dialplan_node" = "100.0.1000015"
        "voice/ors_node" = "100.0.1000056"
        "voice/registrar_node" = "100.0.1000019"
        "voice/rq_node" = "100.0.1000010"
        "voice/sip_node" = "100.0.1000030"
        "voice/sipfe_node" = "100.0.1000009"
        "voice/sipproxy_node" = "100.0.1000019"
            #voicemail_node used in chart
            #"voice/voicemail_node" = "100.0.1000006"
            #voicemail_node available on edge
        "voice/voicemail_node" = "100.0.1000009" */
    }
}

variable "charts" {
    type = map
    default = {
        "cxcontact" = "029.0005.342"
        "designer" = "100.0.122+1407"
        "designer-das" = "100.0.111+0806"
        "designer" = "100.0.122+1407"
        "gauth" = "100.0.009+0153"
        "gca" = "100.0.100+2300"
        "gca-monitoring" = "100.0.100+2300"
        "gcxi" = "100.0.028+0000"
        "gcxi-raa" = "100.0.011+0100"
        "ges" = "100.0.002+0010"
        "gim" = "100.0.116+2900"
        "gsp" = "100.0.100+1400"
        "gvp-configserver" = "100.0.1000056"
        "gvp-mcp" = "100.0.1000070"
        "gvp-rm" = "100.0.1000152"
        "gvp-rs" = "100.0.1000133"
        "gvp-sd" = "100.0.1000055"
        "gws-ingress" = "1.0.28"
        "gws-services" = "1.0.92"
        "iwd" = "100.0.0872006"
        "iwddm-cronjob" = "100.0.006+0003"
        "iwdem" = "100.0.0870488"
        "ixn" = "100.0.003+20"
        "nexus" = "100.0.1222868"
        "pulse" = "100.0.000+0012"
        "dcu" = "100.0.000+0012"
        "init" = "100.0.000+0012"
        "init-tenant" = "100.0.000+0012"
        "lds" = "100.0.000+0012"
        "permissions" = "100.0.000+0012"
        "tenant" = "100.0.1000060"
        "telemetry-service" = "100.0.006+1685"
        "tenant-monitor" = "100.0.1000060"
        "ucsx" = "100.0.0970009"
        "ucsx-addtenant" = "100.0.0970009"
        "voice-agent" = "100.0.1000005"
        "voice-callthread" = "100.0.1000006"
        "voice-config" = "100.0.1000004"
        "voice-dialplan" = "100.0.1000007"
        "voice-ors" = "100.0.1000018"
        "voice-registrar" = "100.0.1000007"
        "voice-rq" = "100.0.1000004"
        "voice-sip" = "100.0.1000017"
        "voice-sipfe" = "100.0.1000006"
        "voice-sipproxy" = "100.0.1000004"
        #"voice-voicemail" = "100.0.1000012" # n/a on edge
        "voice-voicemail" = "100.0.1000011"
        "webrtc-service" = "100.0.041+0000"
        "wwe-nginx" = "9.0.5"
    }
}