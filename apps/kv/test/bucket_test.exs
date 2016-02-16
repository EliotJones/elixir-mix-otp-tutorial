defmodule KV.BucketTest do
    use ExUnit.Case, async: true
    
    setup do
        {:ok, bucket} = KV.Bucket.start_link()
        {:ok, bucket: bucket}
    end
    
    test "stores values by key", %{bucket: bucket} do   
        assert KV.Bucket.get(bucket, "milk") == nil
        
        KV.Bucket.put(bucket, "milk", 3)
        assert KV.Bucket.get(bucket, "milk") == 3
     end
     
     test "deletes values by key", %{bucket: bucket} do
        KV.Bucket.put(bucket, "piss", 5)
        assert KV.Bucket.get(bucket, "piss") == 5
        
        KV.Bucket.delete(bucket, "piss")
        assert KV.Bucket.get(bucket, "piss") == nil
     end
     
     test "delete returns key value", %{bucket: bucket} do
        KV.Bucket.put(bucket, "piss", 5)
        
        assert KV.Bucket.delete(bucket, "piss") == 5
     end
     
     test "put same key twice updates key value", %{bucket: bucket} do
        KV.Bucket.put(bucket, "piss", 5)
        KV.Bucket.put(bucket, "piss", 3) 
        assert KV.Bucket.get(bucket, "piss") == 3
     end
     
     test "add and get works", %{bucket: bucket} do
        assert KV.Bucket.get(bucket, "honey") == nil
        assert KV.Bucket.put_and_get(bucket, "honey", 7) == 7
     end
end