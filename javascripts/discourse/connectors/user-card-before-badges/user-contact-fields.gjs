import Component from "@glimmer/component";
import EmberObject, { set } from "@ember/object";
import { service } from "@ember/service";
import { dasherize } from "@ember/string";
import { isEmpty } from "@ember/utils";

export default class UserContactFields extends Component {
  @service site;

  get userFields() {
    return this.args.user.user_fields;
  }

  get userDetails() {
    const siteUserFields = this.site.get("user_fields");

    if (!isEmpty(siteUserFields)) {
      const userFields = this.userFields;
      return siteUserFields
        .filter((field) => {
          const name = field.get("name");
          return name === "Mobilfunknummer" || name === "Festnetz-Nummer";
        })
        .sortBy("position")
        .map((field) => {
          set(field, "dasherized_name", dasherize(field.get("name")));
          const value = userFields ? userFields[field.get("id")] : null;
          return isEmpty(value) ? null : EmberObject.create({ value, field });
        })
        .compact();
    }
    return [];
  }

  <template>
    {{#each this.userDetails as |detail|}}
      <div class="user-fields">
        <span class="user-field-name">{{detail.field.name}}: </span>
        <span><a href="tel:{{detail.value}}">{{detail.value}}</a></span>
      </div>
    {{/each}}
  </template>
}
