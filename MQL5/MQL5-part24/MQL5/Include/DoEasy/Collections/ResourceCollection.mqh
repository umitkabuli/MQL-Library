//+------------------------------------------------------------------+
//|                                           ResourceCollection.mqh |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                             https://mql5.com/en/users/artmedia70 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://mql5.com/en/users/artmedia70"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Include files                                                    |
//+------------------------------------------------------------------+
#include <Arrays\ArrayObj.mqh>
#include "..\\Services\\FileGen.mqh"
//+------------------------------------------------------------------+
//| Descriptor object class for the library resource file            |
//+------------------------------------------------------------------+
class CResObj : public CObject
  {
private:
   string            m_file_name;      // Path + file name + extension
   string            m_description;    // File text description
public:
//--- Set (1) file name, (2) file description
   void              FileName(const string name)                  { this.m_file_name=name;      }
   void              Description(const string descr)              { this.m_description=descr;   }
//--- Return (1) file name, (2) file description
   string            FileName(void)                         const { return this.m_file_name;    }
   string            Description(void)                      const { return this.m_description;  }
//--- Compare CResObj objects by properties (to search for equal resource objects)
   bool              IsEqual(const CResObj* compared_obj)   const { return this.Compare(compared_obj,0)==0; }
//--- Compare CResObj objects by all properties (for sorting)
   virtual int       Compare(const CObject *node,const int mode=0) const;
//--- Constructor
                     CResObj(void){;}
  };
//+------------------------------------------------------------------+
//| Compare CResObj objects                                          |
//+------------------------------------------------------------------+
int CResObj::Compare(const CObject *node,const int mode=0) const
  {
   const CResObj *obj_compared=node;
   if(mode==0)
      return(this.m_file_name>obj_compared.m_file_name ? 1 : this.m_file_name<obj_compared.m_file_name ? -1 : 0);
   else
      return(this.m_description>obj_compared.m_description ? 1 : this.m_description<obj_compared.m_description ? -1 : 0);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Collection class of resource files descriptor objects            |
//+------------------------------------------------------------------+
class CResourceCollection
  {
private:
//--- List of pointers to descriptor objects
   CArrayObj         m_list_dscr_obj;
//--- Create a file descriptor object and add it to the list
   bool              CreateFileDescrObj(const string file_name,const string descript);
//--- Add a new object to the list of descriptor objects
   bool              AddToList(CResObj* element);
public:
//--- Create a file and add its description to the list
   bool              CreateFile(const ENUM_FILE_TYPE file_type,const string file_name,const string descript,const uchar &file_data_array[]);
//--- Return the (1) list of pointers to descriptor objects, (2) index of the file descriptor object by description
   CArrayObj        *GetList(void)  { return &this.m_list_dscr_obj;  }
   int               GetIndexResObjByDescription(const string file_description);
//--- Constructor
                     CResourceCollection(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CResourceCollection::CResourceCollection()
  {
   this.m_list_dscr_obj.Clear();
   this.m_list_dscr_obj.Sort();
  }
//+------------------------------------------------------------------+
//| Create a file and add its descriptor object to the list          |
//+------------------------------------------------------------------+
bool CResourceCollection::CreateFile(const ENUM_FILE_TYPE file_type,const string file_name,const string descript,const uchar &file_data_array[])
  {
   if(!CFileGen::Create(file_type,file_name,file_data_array))
     {
      if(!::FileIsExist(CFileGen::Name()))
         return false;
     }
   return this.CreateFileDescrObj(CFileGen::Name(),descript);
  }
//+------------------------------------------------------------------+
//| Create a file descriptor object and add it to the list           |
//+------------------------------------------------------------------+
bool CResourceCollection::CreateFileDescrObj(const string file_name,const string descript)
  {
   CResObj *res_dscr=new CResObj();
   if(res_dscr==NULL)
     {
      Print(DFUN,CMessage::Text(MSG_LIB_SYS_FAILED_CREATE_RES_LINK));
      return false;
     }
   res_dscr.FileName(file_name);
   res_dscr.Description(descript);
   if(!this.AddToList(res_dscr))
     {
      delete res_dscr;
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//| Add a new object to the list of file descriptor objects          |
//+------------------------------------------------------------------+
bool CResourceCollection::AddToList(CResObj *element)
  {
   this.m_list_dscr_obj.Sort();
   if(this.m_list_dscr_obj.Search(element)>WRONG_VALUE)
      return false;
   return this.m_list_dscr_obj.Add(element);
  }
//+---------------------------------------------------------------------+
//| Return the index of the file descriptor object by a file description|
//+---------------------------------------------------------------------+
int CResourceCollection::GetIndexResObjByDescription(const string file_description)
  {
   CResObj *obj=new CResObj();
   if(obj==NULL)
      return WRONG_VALUE;
   obj.Description(file_description);
   this.m_list_dscr_obj.Sort(1);
   int index=this.m_list_dscr_obj.Search(obj);
   delete obj;
   return index;
  }
//+------------------------------------------------------------------+
