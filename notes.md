terraform output private_key > ../my_key

aws ecr-public get-login-password --region us-east-1 --profile ankush-katkurwar30 | helm registry login --username AWS --password-stdin public.ecr.aws