import 'react-i18next';
import { resources } from '../../src/declarations/react-i18next/config';

declare module 'react-i18next' {
  type DefaultResources = typeof resources['en_us'];
  interface Resources extends DefaultResources {}
}