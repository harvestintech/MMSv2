import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';
import en_us from './locales/en_us/translation.json';
import zh_hk from './locales/zh_hk/translation.json';

export const resources = {
    en_us: {
        en_us
    },
    zh_hk: {
        zh_hk
    },
  } as const;
  
  i18n.use(initReactI18next).init({
    lng: 'en_us',
    resources,
  });