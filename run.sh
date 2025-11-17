/app/edge-key decrypt -in ./assets/jwt_public.data -out ./assets/jwt_public.pem
/app/edge-key decrypt -in ./assets/jwt_private.data -out ./assets/jwt_private.pem
/app/edge-key decrypt -in ./assets/wxpay_public.data -out ./assets/wxpay_public.pem
/app/edge-key decrypt -in ./assets/wxpay_private.data -out ./assets/wxpay_private.pem
/app/edge-mini run --spec ./server.yaml
