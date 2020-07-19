resource "aws_security_group" "security-group" {
    for_each = var.security-groups

    name        = each.key
    description = each.value.description
    vpc_id      = var.vpc_id
    tags = {
      Name = "elktesting-sg"
    }
}

resource "aws_security_group_rule" "rule" {
    for_each = {
        for sgc in flatten([
            for sg_name, sg_conf in var.security-groups : [
                for rule_name, rule_conf in sg_conf.rules : {
                    sg_name   = sg_name
                    rule_name = rule_name
                    rule_conf = rule_conf
                }
            ]
        ]) : "${sgc.sg_name}_${sgc.rule_name}" => sgc
    }

    description       = each.value.rule_conf.description
    security_group_id = aws_security_group.security-group[each.value.sg_name].id
    cidr_blocks       = each.value.rule_conf.cidr_blocks
    from_port         = each.value.rule_conf.from_port
    ipv6_cidr_blocks  = []
    prefix_list_ids   = []
    protocol          = each.value.rule_conf.protocol
    self              = each.value.rule_conf.self
    to_port           = each.value.rule_conf.to_port
    type              = each.value.rule_conf.type
}
