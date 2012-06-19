require 'xmlsimple'

xml_str = '<PoortegoTransformResponse>
 <ResponseData>
  <Entities>
   <Entity title='google.com' type='domain' />
   <Entity title='www.l.google.com' type='domain'>
    <AdditionalField name='source' value='DigTransform' />
   </Entity>
  </Entities>
  <Links>
   <Link title='CNAME' entity_a='google.com' entity_b='www.l.google.com' />
  </Links>
 </ResponseData>
 <ResponseMessages>
  <Message title='Test' type='Error'>This is a test</Message>
 <ResponseMessages>
</PoortegoTransformResponse>'


response_obj = TransformResponse.new(xml_str)
(response_obj.maltego_transform).resultEntities.each {|entity|
  puts "Type #{entity.entityType} Value #{entity.value}"
  puts ""
  entity.printEntity()  
}