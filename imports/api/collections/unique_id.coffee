
UniqueID = new Mongo.Collection Meteor.settings.public.unique_id_collection

UniqueIDCollection = new SimpleSchema
  currentUniqueID:
    type: Number

UniqueID.attachSchema UniqueIDCollection

UniqueID.allow {
  update: ()->
    return true
}

module.exports.UniqueID = UniqueID
