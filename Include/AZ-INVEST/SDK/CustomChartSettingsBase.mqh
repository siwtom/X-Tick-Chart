#property copyright "Copyright 2018-2020, Level Up Software"
#property link      "http://www.az-invest.eu"

#include <az-invest/sdk/ICustomChartSettings.mqh>
#include <az-invest/sdk/CustomChartInputs.mqh>

class CCustomChartSettingsBase : public ICustomChartSettings
{
   private:

      int                        handle;              

   protected:
   
      string                     settingsFileName;
      string                     chartTypeFileName;
      
      CHART_INDICATOR_SETTINGS   chartIndicatorSettings;
      ALERT_INFO_SETTINGS        alertInfoSettings;
           
   public:
   
                                 CCustomChartSettingsBase();
                                 ~CCustomChartSettingsBase();
                                 
      ALERT_INFO_SETTINGS        GetAlertInfoSettings(void);
      CHART_INDICATOR_SETTINGS   GetChartIndicatorSettings(void);
      
      int                        GetHandle() { return handle; };
      
      void                       Set();
      void                       Save();
      bool                       Load();
      void                       Delete();
      bool                       Changed(double currentRuntimeId);
      
      virtual string             GetSettingsFileName() { return "must_override "+__FUNCTION__; };
      virtual void               SetCustomChartSettings() {};
      virtual uint               CustomChartSettingsToFile(int file_handle) {return 0;};
      virtual uint               CustomChartSettingsFromFile(int file_handle) {return 0;};
      
};

void CCustomChartSettingsBase::CCustomChartSettingsBase()
{
}

void CCustomChartSettingsBase::~CCustomChartSettingsBase()
{
}

ALERT_INFO_SETTINGS CCustomChartSettingsBase::GetAlertInfoSettings()
{
   return this.alertInfoSettings;
}

CHART_INDICATOR_SETTINGS CCustomChartSettingsBase::GetChartIndicatorSettings()
{
   return this.chartIndicatorSettings;
}

void CCustomChartSettingsBase::Save(void)
{    
   if(IS_TESTING || this.chartIndicatorSettings.UsedInEA)
      return;

   this.Delete();

   //
   // Store indicator settings in file
   // 

   handle = FileOpen(this.settingsFileName,FILE_SHARE_READ|FILE_WRITE|FILE_BIN);  
   uint result = 0;
   
   result += CustomChartSettingsToFile(handle);
   result += FileWriteStruct(handle,this.chartIndicatorSettings);
   FileClose(handle);
}


bool CCustomChartSettingsBase::Changed(double currentRuntimeId)
{
   if(MQLInfoInteger((int)MQL5_TESTING))
      return false;
 
   static double prevRuntimeId = -2;
   
   if(prevRuntimeId == -2)
   {
      // prevent reloading on initial load
      prevRuntimeId = currentRuntimeId;
   }
   else if(prevRuntimeId != currentRuntimeId)
   {
      prevRuntimeId = currentRuntimeId;
      return true;
   }

   return false;
}

void CCustomChartSettingsBase::Delete(void)
{
   if(IS_TESTING || this.chartIndicatorSettings.UsedInEA)
      return;

   if(FileIsExist(this.settingsFileName))
      FileDelete(this.settingsFileName);     
}

bool CCustomChartSettingsBase::Load(void)
{
#ifdef SHOW_INDICATOR_INPUTS
   Set();
   return true;
#else 

   //
   // Load indicator settings from file
   // 

   if(!FileIsExist(this.settingsFileName))
      return false;
      
   handle = FileOpen(this.settingsFileName,FILE_SHARE_READ|FILE_BIN);  
   if(handle == INVALID_HANDLE)
      return false;
        
   if(CustomChartSettingsFromFile(handle) <= 0)
   {
      Print("Failed loading settings in "+__FUNCTION__+" ("+__FILE__+", line#"+(string)__LINE__+")");
      FileClose(handle); 
      return false;
   }
   
   if(FileReadStruct(handle,this.chartIndicatorSettings) <= 0)
   {
      Print("Failed loading settings in "+__FUNCTION__+" ("+__FILE__+", line#"+(string)__LINE__+")");
      FileClose(handle); 
      return false;
   }
   
   FileClose(handle);
   return true;

#endif 
}

void CCustomChartSettingsBase::Set(void)
{
#ifdef SHOW_INDICATOR_INPUTS

   SetCustomChartSettings();
      
   //
   //
   //

   #ifndef USE_CUSTOM_SYMBOL     
          
      chartIndicatorSettings.MA1on = MA1on;
      chartIndicatorSettings.MA1lineType = MA1lineType;
      chartIndicatorSettings.MA1period = MA1period;
      chartIndicatorSettings.MA1method = MA1method;
      chartIndicatorSettings.MA1applyTo = MA1applyTo;
      chartIndicatorSettings.MA1shift = MA1shift;
      chartIndicatorSettings.MA1priceLabel = MA1priceLabel;
      
      chartIndicatorSettings.MA2on = MA2on;
      chartIndicatorSettings.MA2lineType = MA2lineType;
      chartIndicatorSettings.MA2period = MA2period;
      chartIndicatorSettings.MA2method = MA2method;
      chartIndicatorSettings.MA2applyTo = MA2applyTo;
      chartIndicatorSettings.MA2shift = MA2shift;
      chartIndicatorSettings.MA2priceLabel = MA2priceLabel;
      
      chartIndicatorSettings.MA3on = MA3on;
      chartIndicatorSettings.MA3lineType = MA3lineType;
      chartIndicatorSettings.MA3period = MA3period;
      chartIndicatorSettings.MA3method = MA3method;
      chartIndicatorSettings.MA3applyTo = MA3applyTo;
      chartIndicatorSettings.MA3shift = MA3shift;
      chartIndicatorSettings.MA3priceLabel = MA3priceLabel;
      
      chartIndicatorSettings.MA4on = MA4on;
      chartIndicatorSettings.MA4lineType = MA4lineType;
      chartIndicatorSettings.MA4period = MA4period;
      chartIndicatorSettings.MA4method = MA4method;
      chartIndicatorSettings.MA4applyTo = MA4applyTo;
      chartIndicatorSettings.MA4shift = MA4shift;
      chartIndicatorSettings.MA4priceLabel = MA4priceLabel;
      
      chartIndicatorSettings.ShowChannel = ShowChannel;
      chartIndicatorSettings.ChannelAppliedPrice = ChannelAppliedPrice;
      chartIndicatorSettings.ChannelPeriod = ChannelPeriod;
      chartIndicatorSettings.ChannelAtrPeriod = ChannelAtrPeriod;
      chartIndicatorSettings.ChannelMultiplier = ChannelMultiplier;
      chartIndicatorSettings.ChannelBandsDeviations = ChannelBandsDeviations;
      chartIndicatorSettings.ChannelPriceLabel = ChannelPriceLabel;
      chartIndicatorSettings.ChannelMidPriceLabel = ChannelMidPriceLabel;
      
      chartIndicatorSettings.ShiftObj = ShiftObj;
      chartIndicatorSettings.UsedInEA = UsedInEA;
   
      //
      //
      //
         
      alertInfoSettings.TradingSessionTime = TradingSessionTime;
         
      alertInfoSettings.TopBottomPaddingPercentage = TopBottomPaddingPercentage;
      alertInfoSettings.showPiovots = showPivots;
      
      alertInfoSettings.pivotPointCalculationType = pivotPointCalculationType;
      alertInfoSettings.Rcolor = RColor;
      alertInfoSettings.Pcolor = PColor;
      alertInfoSettings.Scolor = SColor;
      alertInfoSettings.PDHColor = PDHColor;
      alertInfoSettings.PDLColor = PDLColor;
      alertInfoSettings.PDCColor = PDCColor;
      alertInfoSettings.showNextBarLevels = showNextBarLevels;
      alertInfoSettings.HighThresholdIndicatorColor = HighThresholdIndicatorColor;
      alertInfoSettings.LowThresholdIndicatorColor = LowThresholdIndicatorColor;
      alertInfoSettings.showCurrentBarOpenTime = showCurrentBarOpenTime;
      alertInfoSettings.InfoTextColor = InfoTextColor;
      
      alertInfoSettings.NewBarAlert = NewBarAlert; 
      alertInfoSettings.ReversalBarAlert = ReversalBarAlert;
      alertInfoSettings.MaCrossAlert = MaCrossAlert ;    
      alertInfoSettings.UseAlertWindow = UseAlertWindow;  
      alertInfoSettings.UseSound = UseSound;
      alertInfoSettings.UsePushNotifications = UsePushNotifications;
      
      alertInfoSettings.SoundFileBull = SoundFileBull;
      alertInfoSettings.SoundFileBear = SoundFileBear;
      alertInfoSettings.DisplayAsBarChart = DisplayAsBarChart;
   
   #endif
#endif
}

