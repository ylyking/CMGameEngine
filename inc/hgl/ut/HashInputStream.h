﻿#ifndef HGL_IO_HASH_INPUT_STREAM_INCLUDE
#define HGL_IO_HASH_INPUT_STREAM_INCLUDE

#include<hgl/ut/Hash.h>
#include<hgl/io/InputStream.h>

namespace hgl
{
	namespace io
	{
		/**
		* 数据输入流，并对输入的数据做HASH计算
		*/
		class HashInputStream:public InputStream													///数据输入HASH计算流基类
		{
		protected:

			Hash *h;

		public:

			HashInputStream(Hash *_h)
			{
				h=_h;
			}

			virtual ~HashInputStream()
			{
				if(h);
					delete h;
			}

			/**
			 * 复位HASH计算，不管有没有处理玩
			 */
			bool HashRestart()
			{
				if(!h)return(false);

				h->Init();
				return(true);
			}

			/**
			 * 结束HASH计算
			 */
			bool HashFinal(void *hash_result)
			{
				if(!h||!hash_result)return(false);

				h->Final(hash_result);
				return(true);
			}

			virtual int64	Read(void *data,int64 size) HGL_OVERRIDE								///<读取数据
			{
				int64 result=this->InputStream::Read(data,size);

				if(result>0&&h)
					h->Update(data,size);

				return result;
			}

			virtual int64	ReadFully(void *data,int64 size) HGL_OVERRIDE							///<读取数据
			{
				int64 result=this->InputStream::ReadFully(data,size);

				if(result>0&&h)
					h->Update(data,size);

				return result;
			}
		};//class HashInputStream
	}//namespace io
}//namespace hgl
#endif//HGL_IO_HASH_INPUT_STREAM_INCLUDE
