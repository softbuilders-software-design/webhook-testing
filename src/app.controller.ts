import { Body, Controller, Get, Post, UseGuards } from '@nestjs/common';
import { AppService } from './app.service';
import { WebhookAuthGuard } from './webhook-auth.guard';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) { }

  @Get()
  getHello(): string {
    return this.appService.getHello();
  }

  @Post('webhook')
  @UseGuards(WebhookAuthGuard)
  webhook(@Body() body: any) {
    console.log(body);
    return { message: 'Webhook received successfully', data: body };
  }
}
