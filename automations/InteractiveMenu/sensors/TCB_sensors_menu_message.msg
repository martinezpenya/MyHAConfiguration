>-
  {{"\U0001f321 ***Temp Sensors*** \U0001f321\n"}}
  {{"\n"}}{% for entity_id in states.group.temperature_sensors.attributes.entity_id %}{% set domain, device = entity_id.split('.') %}{{"- `" + states[domain][device].state_with_unit + " ` ___(" + states[domain][device].name + ")___ \n"}}{% endfor %}
