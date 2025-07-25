import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { WebhookAuthGuard } from './webhook-auth.guard';

@Module({
  imports: [],
  controllers: [AppController],
  providers: [AppService, WebhookAuthGuard],
})
export class AppModule {}
