module SerializerSpecHelper
  def serialize_as_json(obj, opts = {})
    serializer_class = opts.delete(:serializer_class) || described_class
    serializer = serializer_class.send(:new, obj, opts)
    adapter = ActiveModelSerializers::Adapter.create(serializer)
    JSON.parse(adapter.to_json)
  end
end
